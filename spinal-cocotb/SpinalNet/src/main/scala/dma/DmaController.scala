package dma

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.fsm._

case class DmaConfig(
    addressWidth: Int = 32,
    bufDepth: Int = 24,
    burstLen: Int = 16,
    dataWidth: Int = 32,
    littleEndien: Boolean = true,
    idWidth: Int = 4,
    xySizeMax: Int = 65536
) {
  val busByteSize = dataWidth / 8
  val burstLenWidth = 8 // log2Up(burstLen)
  val burstByteSize = burstLen * busByteSize
  val fullStrbBits = scala.math.pow(2, busByteSize).toInt - 1 // all bits valid
  val xySizeWidth = log2Up(xySizeMax)

  require(dataWidth % 8 == 0, s"$dataWidth % 8 == 0 assert failed")
  require(burstLen <= xySizeMax, s"$burstLen < $xySizeMax assert failed")
  require(burstLen <= 256, s"$burstLen < 256 assert failed")
  require(
    xySizeWidth < addressWidth,
    s"$xySizeWidth < $addressWidth assert failed"
  )

  val axiConfig = Axi4Config(
    addressWidth = addressWidth,
    dataWidth = dataWidth,
    idWidth = idWidth,
    useId = true,
    useQos = false,
    useRegion = false,
    useLock = false,
    useCache = false,
    useProt = false
  )
}

class DmaController(dmaConfig: DmaConfig) extends Component {
  val io = new Bundle {
    val param = slave(Param(dmaConfig.addressWidth, dmaConfig.xySizeWidth))
    val axi = master(Axi4(dmaConfig.axiConfig))
    val ctrl = slave(Ctrl())
  }

  // val buf = new StreamFifo(
  //   dataType = Bits(dmaConfig.dataWidth bits),
  //   depth = dmaConfig.bufDepth
  // )

  val read = new DmaRead(dmaConfig)
  val write = new DmaWrite(dmaConfig)
  read.io.ctrl.start := io.ctrl.start
  read.io.ctrl.halt := io.ctrl.halt
  read.io.param := io.param
  //buf.io.push << read.io.dout
  write.io.ctrl.start := io.ctrl.start
  write.io.ctrl.halt := io.ctrl.halt
  write.io.param := io.param
  //write.io.din << buf.io.pop
  write.io.din << read.io.dout.queue(dmaConfig.bufDepth)

  io.ctrl.busy := read.io.ctrl.busy || write.io.ctrl.busy
  io.ctrl.done := write.io.ctrl.done // No need to consider read done

  io.axi << read.io.axiR
  io.axi << write.io.axiW
}

class DmaRead(dmaConfig: DmaConfig) extends Component {
  val io = new Bundle {
    val dout = master(Stream(Bits(dmaConfig.dataWidth bits)))
    val param = slave(Param(dmaConfig.addressWidth, dmaConfig.xySizeWidth))
    val axiR = master(Axi4ReadOnly(dmaConfig.axiConfig))
    val ctrl = slave(Ctrl())
  }
  io.ctrl.done := False

  val busyReg = Reg(Bool) init (False)
  when(io.ctrl.start) {
    busyReg := True
  } elsewhen (io.ctrl.done) {
    busyReg := False
  }
  io.ctrl.busy := busyReg

  val id = 3

  val arValidReg = Reg(False) init (False)
  val burstLenReg = Reg(UInt(dmaConfig.burstLenWidth bits)) init (0)
  val nxtBurstLen = UInt(dmaConfig.burstLenWidth bits)

  val curRowAddrReg = Reg(UInt(dmaConfig.addressWidth bits)) init (0)
  val alignOffsetReg = Reg(UInt(log2Up(dmaConfig.busByteSize) bits)) init (0)
  val alignOffsetNxt = UInt(
    log2Up(dmaConfig.busByteSize) bits
  ) // The alignment offset of row start address to bus width
  val curAlignedAddrReg = Reg(UInt(dmaConfig.addressWidth bits)) init (0)
  val curAlignedRowAddr = curRowAddrReg - alignOffsetReg
  val rowByteSize = io.param.xsize
  val nxtAlignedAddr =
    curAlignedAddrReg + (burstLenReg << log2Up(dmaConfig.busByteSize))
  val srcRowGap = io.param.xsize + io.param.srcystep
  val nxtRowAddr = curRowAddrReg + srcRowGap

  val runSignal = ~io.ctrl.halt
  val idMatch = io.axiR.r.id === id

  io.axiR.ar.id := id
  io.axiR.ar.addr := curAlignedAddrReg // read addr
  io.axiR.ar.len := burstLenReg - 1
  io.axiR.ar.size := log2Up(dmaConfig.dataWidth)
  io.axiR.ar.burst := Axi4.burst.INCR
  if (dmaConfig.axiConfig.useLock) {
    io.axiR.ar.lock := Axi4.lock.NORMAL
  }
  if (dmaConfig.axiConfig.useCache) {
    io.axiR.ar.cache := B(0, 2 bits) ## io.param.cf ## io.param.bf
  }
  if (dmaConfig.axiConfig.useProt) {
    io.axiR.ar.prot := 2
  }
  io.axiR.ar.valid := arValidReg

  val dataPreReg = Reg(Bits(dmaConfig.dataWidth bits)) init (0)
  val curBeatBytes = UInt((log2Up(dmaConfig.busByteSize) + 1) bits)
  val output = Bits(dmaConfig.dataWidth bits)
  val doutValid = False
  val rReady = False

  // Save read data to StreamFifo
  io.dout.valid := doutValid
  io.axiR.r.ready := rReady
  io.dout.payload := output

  val rowReadCntReg =
    Reg(UInt(dmaConfig.xySizeWidth bits)) init (0) // Number of rows read
  val rowReadCntNxt = rowReadCntReg + 1
  val colByteReadCntReg =
    Reg(
      UInt(dmaConfig.xySizeWidth bits)
    ) init (0) // Number of bytes read in a row
  val colByteReadCntNxt = colByteReadCntReg + curBeatBytes
  val colRemainByteCntReg = Reg(
    UInt(dmaConfig.xySizeWidth bits)
  ) init (rowByteSize) // Number of bytes left to read
  val colRemainByteCntNxt = colRemainByteCntReg - curBeatBytes

  val rowFirstBurstReg = Reg(Bool) init (False)
  val rowFirstBeatReg = Reg(Bool) init (False)
  //val rowLastBeat         = False//colRemainByteCntReg <= dmaConfig.busByteSize
  val nxtRow = False

  val fsmR = new StateMachine {
    val IDLE: State = new State with EntryPoint {
      whenIsActive {
        arValidReg := False
        alignOffsetReg := 0
        burstLenReg := 0
        curRowAddrReg := io.param.sar - srcRowGap // TODO: refactor this
        curAlignedAddrReg := 0

        dataPreReg := 0

        rowFirstBurstReg := False
        rowFirstBeatReg := False

        rowReadCntReg := 0
        colByteReadCntReg := 0
        colRemainByteCntReg := rowByteSize

        when(runSignal && io.ctrl.start) {
          arValidReg := True
          alignOffsetReg := alignOffsetNxt
          burstLenReg := nxtBurstLen

          curRowAddrReg := io.param.sar
          curAlignedAddrReg := io.param.sar - alignOffsetNxt
          //colRemainByteCntReg := rowByteSize

          rowFirstBeatReg := True
          rowFirstBurstReg := True
          nxtRow := True

          goto(AR)
        }
      }
    }

    val AR: State = new State { // Send AXI read address
      whenIsActive {
        when(runSignal && io.axiR.ar.valid && io.axiR.ar.ready) {
          arValidReg := False
          when(alignOffsetReg =/= 0 && rowFirstBeatReg) {
            goto(FR)
          } otherwise {
            goto(BR)
          }
        }
      }
    }

    val FR: State = new State { // First read, read non-aligned data
      whenIsActive {
        rReady := True
        doutValid := False // No output, just cache first read

        when(runSignal && io.axiR.r.valid && io.axiR.r.ready) {
          colByteReadCntReg := colByteReadCntNxt
          colRemainByteCntReg := colRemainByteCntNxt
          rowFirstBeatReg := False

          when(io.axiR.r.last) {
            // Minimum number of bytes to transfer is 2 * busByteSize
            curAlignedAddrReg := nxtAlignedAddr
            burstLenReg := nxtBurstLen
            arValidReg := True

            goto(AR)
          } otherwise {
            goto(BR)
          }
        }
      }
    }

    val BR: State = new State { // Burst aligned read
      whenIsActive {
        doutValid := io.axiR.r.valid
        rReady := io.dout.ready

        when(runSignal && io.axiR.r.valid && io.axiR.r.ready) {
          colByteReadCntReg := colByteReadCntNxt
          colRemainByteCntReg := colRemainByteCntNxt
          rowFirstBeatReg := False
        }

        when(
          runSignal && io.axiR.r.valid && io.axiR.r.ready && io.axiR.r.last
        ) { // Prepare next read address
          rowFirstBurstReg := False
          //burstLenReg := nxtBurstLen

          when(colByteReadCntNxt < rowByteSize) { // Continue read same row
            curAlignedAddrReg := nxtAlignedAddr
            burstLenReg := nxtBurstLen
            arValidReg := True

            goto(AR)
          } otherwise { // Finish read one row
            //rowLastBeat       := True
            colByteReadCntReg := 0
            colRemainByteCntReg := rowByteSize

            when(alignOffsetReg =/= 0) {
              goto(LAST)
            } elsewhen (rowReadCntNxt < io.param.ysize) {
              burstLenReg := nxtBurstLen
              //colRemainByteCntReg := rowByteSize

              rowReadCntReg := rowReadCntNxt
              rowFirstBeatReg := True
              rowFirstBurstReg := True

              nxtRow := True
              alignOffsetReg := alignOffsetNxt
              curAlignedAddrReg := nxtRowAddr - alignOffsetNxt
              curRowAddrReg := nxtRowAddr

              arValidReg := True
              goto(AR)
            } otherwise { // Finish read all rows
              io.ctrl.done := True
              goto(IDLE)
            }
          }
        }
      }
    }

    val LAST: State = new State { // Send last beat when non-aligned read
      whenIsActive {
        rReady := False
        doutValid := True
        when(runSignal && io.dout.valid && io.dout.ready) {
          when(rowReadCntNxt < io.param.ysize) { // Send next row address
            burstLenReg := nxtBurstLen
            //colRemainByteCntReg := rowByteSize

            rowReadCntReg := rowReadCntNxt
            rowFirstBeatReg := True
            rowFirstBurstReg := True

            nxtRow := True
            alignOffsetReg := alignOffsetNxt
            curAlignedAddrReg := nxtRowAddr - alignOffsetNxt
            curRowAddrReg := nxtRowAddr

            arValidReg := True
            goto(AR)
          } otherwise { // Finish read all rows
            io.ctrl.done := True
            goto(IDLE)
          }
        }
      }
    }
  }

  val computeNextReadBurstLen = new Area {
    if (dmaConfig.busByteSize > 1) {
      alignOffsetNxt := nxtRowAddr((log2Up(dmaConfig.busByteSize) - 1) downto 0)
    } else {
      alignOffsetNxt := 0
    }

    val nxtAlignedRowAddr = nxtRowAddr - alignOffsetNxt
    val tmpBurstByteSizeIn4K = (4096 - nxtAlignedRowAddr(0, 12 bits))
    val nxtAlignedRowByteSize = rowByteSize + alignOffsetNxt
    val rowCross4K = (tmpBurstByteSizeIn4K < dmaConfig.burstByteSize
      && tmpBurstByteSizeIn4K < nxtAlignedRowByteSize)
    when(nxtRow) {
      when(rowCross4K) {
        nxtBurstLen := (tmpBurstByteSizeIn4K >> (log2Up(
          dmaConfig.busByteSize
        ))).resized
      } elsewhen (dmaConfig.burstByteSize < nxtAlignedRowByteSize) {
        nxtBurstLen := dmaConfig.burstLen
      } otherwise {
        when(
          nxtAlignedRowByteSize(
            (log2Up(dmaConfig.busByteSize) - 1) downto 0
          ) =/= 0
        ) {
          nxtBurstLen := ((nxtAlignedRowByteSize >> (log2Up(
            dmaConfig.busByteSize
          ))) + 1).resized
        } otherwise {
          nxtBurstLen := (nxtAlignedRowByteSize >> (log2Up(
            dmaConfig.busByteSize
          ))).resized
        }
      }
    } elsewhen (colRemainByteCntNxt < dmaConfig.burstByteSize) {
      when(
        colRemainByteCntReg((log2Up(dmaConfig.busByteSize) - 1) downto 0) =/= 0
      ) {
        nxtBurstLen := ((colRemainByteCntNxt >> (log2Up(
          dmaConfig.busByteSize
        ))) + 1).resized
      } otherwise {
        nxtBurstLen := (colRemainByteCntNxt >> (log2Up(
          dmaConfig.busByteSize
        ))).resized
      }
    } otherwise {
      nxtBurstLen := dmaConfig.burstLen
    }
  }

  val computeNextReadPayload = new Area {
    // Burst length is at least 2, the minimum data size to transfer is twice bus bytes
    when(rowFirstBeatReg) {
      // Mask padding bits as invalid for first write beat
      curBeatBytes := dmaConfig.busByteSize - alignOffsetReg
      // } elsewhen (rowLastBeat) {
      //   // colRemainByteCntReg is smaller than dmaConfig.busByteSize
      //   curBeatBytes := (rowByteSize - colByteReadCntReg).resized//colRemainByteCntReg.resized
    } otherwise {
      curBeatBytes := dmaConfig.busByteSize
    }

    when(runSignal && io.axiR.r.valid && io.axiR.r.ready) {
      dataPreReg := io.axiR.r.data
    }

    when(alignOffsetReg =/= 0) {
      switch(alignOffsetReg) {
        for (off <- 0 until dmaConfig.busByteSize) {
          is(off) {
            val paddingWidth = off << log2Up(8) // off * 8
            val restWidth =
              (dmaConfig.busByteSize - off) << log2Up(
                8
              ) // (busByteSize - off) * 8

            if (dmaConfig.littleEndien) {
              output := io.axiR.r.data(0, paddingWidth bits) ## dataPreReg(
                paddingWidth,
                restWidth bits
              )
            } else {
              output := dataPreReg(paddingWidth, restWidth bits) ## io.axiR.r
                .data(0, paddingWidth bits)
            }
          }
        }
      }
    } otherwise {
      output := io.axiR.r.data
    }
  }
}

class DmaWrite(dmaConfig: DmaConfig) extends Component {
  val io = new Bundle {
    val din = slave(Stream(Bits(dmaConfig.dataWidth bits)))
    val param = slave(Param(dmaConfig.addressWidth, dmaConfig.xySizeWidth))
    val axiW = master(Axi4WriteOnly(dmaConfig.axiConfig))
    val ctrl = slave(Ctrl())
  }

  io.ctrl.done := False

  val busyReg = Reg(Bool) init (False)
  when(io.ctrl.start) {
    busyReg := True
  } elsewhen (io.ctrl.done) {
    busyReg := False
  }
  io.ctrl.busy := busyReg

  val id = 5

  val awValidReg = Reg(False) init (False)
  val burstLenReg = Reg(UInt(dmaConfig.burstLenWidth bits)) init (0)
  val nxtBurstLen = UInt(dmaConfig.burstLenWidth bits)

  val curRowAddrReg = Reg(UInt(dmaConfig.addressWidth bits)) init (0)
  val alignOffsetReg = Reg(UInt(log2Up(dmaConfig.busByteSize) bits)) init (0)
  val alignOffsetNxt = UInt(
    log2Up(dmaConfig.busByteSize) bits
  ) // The alignment offset of row start address to bus width
  val curAlignedAddrReg = Reg(UInt(dmaConfig.addressWidth bits)) init (0)
  val curAlignedRowAddr = curRowAddrReg - alignOffsetReg
  val rowByteSize = io.param.xsize
  val nxtAlignedAddr =
    curAlignedAddrReg + (burstLenReg << log2Up(dmaConfig.busByteSize))
  val dstRowGap = io.param.xsize + io.param.dstystep
  val nxtRowAddr = curRowAddrReg + dstRowGap
  val beatCnt = Counter(
    start = 0,
    end = dmaConfig.burstLen
  ) // Count how many transfers in a burst

  val runSignal = ~io.ctrl.halt
  val idMatch = io.axiW.b.id === id

  io.axiW.aw.id := id
  io.axiW.aw.addr := curAlignedAddrReg // write addr
  io.axiW.aw.len := burstLenReg - 1
  io.axiW.aw.size := log2Up(dmaConfig.dataWidth)
  io.axiW.aw.burst := Axi4.burst.INCR
  if (dmaConfig.axiConfig.useProt) {
    io.axiW.aw.lock := Axi4.lock.NORMAL
  }
  if (dmaConfig.axiConfig.useProt) {
    io.axiW.aw.cache := B(0, 2 bits) ## io.param.cf ## io.param.bf
  }
  if (dmaConfig.axiConfig.useProt) {
    io.axiW.aw.prot := 2 // Unprivileged non-secure data access
  }
  io.axiW.aw.valid := awValidReg

  val bReadyReg = Reg(Bool) init (False)
  io.axiW.b.ready := bReadyReg

  io.axiW.w.last := beatCnt === (burstLenReg - 1)
  when(io.axiW.w.last) {
    beatCnt.clear()
  }

  val dinPrevReg = Reg(Bits(dmaConfig.dataWidth bits)) init (0)
  val curBeatBytes = UInt((log2Up(dmaConfig.busByteSize) + 1) bits)
  val strobe = UInt(dmaConfig.busByteSize bits)
  val payload = Bits(dmaConfig.dataWidth bits)
  val dinReady = False
  val wValid = False

  // Send write data to AXI write channel
  io.axiW.w.valid := wValid
  io.din.ready := dinReady
  io.axiW.w.data := payload
  io.axiW.w.strb := strobe.asBits

  val rowWriteCntReg =
    Reg(UInt(dmaConfig.xySizeWidth bits)) init (0) // Number of rows write
  val rowWriteCntNxt = rowWriteCntReg + 1
  val colByteWriteCntReg =
    Reg(
      UInt(dmaConfig.xySizeWidth bits)
    ) init (0) // Number of bytes written in a row
  val colByteWriteCntNxt =
    colByteWriteCntReg + curBeatBytes // Each burst beat transfers bus width data including invalid ones
  val colRemainByteCntReg = Reg(
    UInt(dmaConfig.xySizeWidth bits)
  ) init (rowByteSize) // Number of bytes left to write
  val colRemainByteCntNxt = colRemainByteCntReg - curBeatBytes

  val rowFirstBurstReg = Reg(Bool) init (False)
  val rowFirstBeatReg = Reg(Bool) init (False)
  val rowLastBeat = colRemainByteCntReg <= dmaConfig.busByteSize
  val nxtRow = False

  val fsmW = new StateMachine {
    val IDLE: State = new State with EntryPoint {
      whenIsActive {
        awValidReg := False
        alignOffsetReg := 0
        burstLenReg := 0
        curRowAddrReg := io.param.dar - dstRowGap // TODO: refactor this
        curAlignedAddrReg := 0

        bReadyReg := False
        dinPrevReg := 0

        rowFirstBurstReg := False
        rowFirstBeatReg := False

        rowWriteCntReg := 0
        colByteWriteCntReg := 0
        colRemainByteCntReg := rowByteSize

        when(runSignal && io.ctrl.start) {
          awValidReg := True
          alignOffsetReg := alignOffsetNxt
          burstLenReg := nxtBurstLen

          curRowAddrReg := io.param.dar
          curAlignedAddrReg := io.param.dar - alignOffsetNxt
          //colRemainByteCntReg := rowByteSize

          rowFirstBeatReg := True
          rowFirstBurstReg := True
          nxtRow := True
          //goto(AW)
          goto(W)
        }
      }
    }
    /*
    val AW: State = new State {  // Send AXI write address
      whenIsActive {
        when (runSignal && io.axiW.aw.valid && io.axiW.aw.ready) {
          awValidReg := False
          goto(W)
        }
      }
    }
     */
    val W: State = new State {
      onEntry {
        beatCnt.clear()
      }
      whenIsActive {
        when(runSignal && io.axiW.aw.valid && io.axiW.aw.ready) {
          awValidReg := False
        }

        dinReady := io.axiW.w.ready
        wValid := io.din.valid

        when(runSignal && io.axiW.w.valid && io.axiW.w.ready) {
          beatCnt.increment()

          colByteWriteCntReg := colByteWriteCntNxt
          colRemainByteCntReg := colRemainByteCntNxt
          rowFirstBeatReg := False
        }

        when(runSignal) {
          when(io.axiW.w.valid && io.axiW.w.ready) {
            when(io.axiW.w.last) {
              rowFirstBurstReg := False
              beatCnt.clear()

              bReadyReg := True
              goto(B)
            } elsewhen (alignOffsetReg =/= 0 && colRemainByteCntNxt < dmaConfig.busByteSize) {
              goto(LAST)
            }
          }
        }
      }
    }

    val LAST: State = new State {
      whenIsActive {
        dinReady := False
        wValid := True

        when(
          runSignal && io.axiW.w.last && io.axiW.w.valid && io.axiW.w.ready
        ) {
          rowFirstBurstReg := False
          beatCnt.clear()

          bReadyReg := True
          goto(B)
        }
      }
    }

    val B: State = new State {
      whenIsActive {
        // TODO: handle BRESP error
        when(runSignal && io.axiW.b.valid && io.axiW.b.ready) { // Prepare next write address
          bReadyReg := False
          burstLenReg := nxtBurstLen

          when(colByteWriteCntReg < rowByteSize) { // Continue write same row
            curAlignedAddrReg := nxtAlignedAddr
            awValidReg := True

            //goto(AW)
            goto(W)
          } otherwise { // Finish write one row
            colByteWriteCntReg := 0
            colRemainByteCntReg := rowByteSize

            when(rowWriteCntNxt < io.param.ysize) {
              rowWriteCntReg := rowWriteCntNxt
              rowFirstBeatReg := True
              rowFirstBurstReg := True

              nxtRow := True
              alignOffsetReg := alignOffsetNxt
              curAlignedAddrReg := nxtRowAddr - alignOffsetNxt
              curRowAddrReg := nxtRowAddr

              awValidReg := True
              //goto(AW)
              goto(W)
            } otherwise { // Finish write all rows
              io.ctrl.done := True
              goto(IDLE)
            }
          }
        }
      }
    }
  }

  val computeNextWriteBurstLen = new Area {
    if (dmaConfig.busByteSize > 1) {
      alignOffsetNxt := nxtRowAddr((log2Up(dmaConfig.busByteSize) - 1) downto 0)
    } else {
      alignOffsetNxt := 0
    }

    val nxtAlignedRowAddr = nxtRowAddr - alignOffsetNxt
    val tmpBurstByteSizeIn4K = (4096 - nxtAlignedRowAddr(0, 12 bits))
    val nxtAlignedRowByteSize = rowByteSize + alignOffsetNxt
    val rowCross4K = (tmpBurstByteSizeIn4K < dmaConfig.burstByteSize
      && tmpBurstByteSizeIn4K < nxtAlignedRowByteSize)
    when(nxtRow) {
      when(rowCross4K) {
        nxtBurstLen := (tmpBurstByteSizeIn4K >> (log2Up(
          dmaConfig.busByteSize
        ))).resized
      } elsewhen (dmaConfig.burstByteSize < nxtAlignedRowByteSize) {
        nxtBurstLen := dmaConfig.burstLen
      } otherwise {
        when(
          nxtAlignedRowByteSize(
            (log2Up(dmaConfig.busByteSize) - 1) downto 0
          ) =/= 0
        ) {
          nxtBurstLen := ((nxtAlignedRowByteSize >> (log2Up(
            dmaConfig.busByteSize
          ))) + 1).resized
        } otherwise {
          nxtBurstLen := (nxtAlignedRowByteSize >> (log2Up(
            dmaConfig.busByteSize
          ))).resized
        }
      }
    } elsewhen (colRemainByteCntReg < dmaConfig.burstByteSize) {
      when(
        colRemainByteCntReg((log2Up(dmaConfig.busByteSize) - 1) downto 0) =/= 0
      ) {
        nxtBurstLen := ((colRemainByteCntReg >> (log2Up(
          dmaConfig.busByteSize
        ))) + 1).resized
      } otherwise {
        nxtBurstLen := (colRemainByteCntReg >> (log2Up(
          dmaConfig.busByteSize
        ))).resized
      }
    } otherwise {
      nxtBurstLen := dmaConfig.burstLen
    }
  }

  val computeNextWritePayload = new Area {
    // Burst length is at least 2, the minimum data to transfer is twice bus bytes
    when(rowFirstBeatReg) {
      // Mask padding bits as invalid for first write beat
      strobe := (dmaConfig.fullStrbBits - ((U(1) << alignOffsetReg) - 1))
      curBeatBytes := dmaConfig.busByteSize - alignOffsetReg
    } elsewhen (rowLastBeat) {
      // In this case colRemainByteCntReg is smaller than dmaConfig.busByteSize
      strobe := ((U(1) << colRemainByteCntReg) - 1).resized
      curBeatBytes := colRemainByteCntReg.resized
    } otherwise {
      strobe := dmaConfig.fullStrbBits
      curBeatBytes := dmaConfig.busByteSize
    }

    when(io.din.valid && io.din.ready) {
      dinPrevReg := io.din.payload
    }

    switch(alignOffsetReg) {
      for (off <- 0 until dmaConfig.busByteSize) {
        is(off) {
          val paddingWidth = off << log2Up(8) // off * 8
          val restWidth =
            (dmaConfig.busByteSize - off) << log2Up(
              8
            ) // (busByteSize - off) * 8

          if (dmaConfig.littleEndien) {
            payload := io.din.payload(0, restWidth bits) ## dinPrevReg(
              restWidth,
              paddingWidth bits
            )
          } else {
            payload := dinPrevReg(restWidth, paddingWidth bits) ## io.din
              .payload(0, restWidth bits)
          }
        }
      }
    }
  }
}

object DmaController {
  def main(args: Array[String]): Unit = {
    val dmaConfig = DmaConfig(
      addressWidth = 16,
      burstLen = 8,
      bufDepth = 24,
      dataWidth = 8,
      xySizeMax = 256
    )
    SpinalVerilog(new DmaController(dmaConfig)) printPruned ()
  }
}
