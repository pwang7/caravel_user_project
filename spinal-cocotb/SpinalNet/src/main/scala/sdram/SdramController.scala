package sdram

import scala.math.BigDecimal.RoundingMode
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.fsm._
import spinal.lib.io.TriStateArray
import spinal.lib.memory.sdram._
import spinal.lib.memory.sdram.sdr.{MT48LC16M16A2, SdramTimings, SdramInterface}

case class SdramConfig(
    CAS: Int = 3,
    addressWidth: Int = 32,
    burstLen: Int = 16,
    busDataWidth: Int = 32,
    idWidth: Int = 4
) {
  val busByteSize = busDataWidth / 8
  val burstLenWidth = 8 // AXI4 burst length width // log2Up(burstLen)
  val burstByteSize = burstLen * busByteSize
  val fullStrbBits = scala.math.pow(2, busByteSize).toInt - 1 // all bits valid
  val bufDepth = burstLen * 4

  require(
    busDataWidth % 8 == 0,
    s"${busDataWidth} % 8 == 0 bus data width assertaion failed"
  )
  require(burstLen <= 256, s"$burstLen < 256 burst lenth assertion failed")

  val axiConfig = Axi4Config(
    addressWidth = addressWidth,
    dataWidth = busDataWidth,
    idWidth = idWidth,
    useId = true,
    useQos = false,
    useRegion = false,
    useLock = false,
    useCache = false,
    useProt = false
  )
}

class SdramController(l: SdramLayout, t: SdramTimings, c: SdramConfig)
    extends Component {
  require(c.burstLen >= 4, "burst length at least 4")
  require(
    c.burstLen <= l.columnSize,
    "burst length should be less than column size"
  )
  require(
    c.busDataWidth % l.dataWidth == 0,
    "AXI bus data width is not divisible by SDRAM data width"
  )

  val DATA_WIDTH_MULIPLER = c.busDataWidth / l.dataWidth
  val dataWidthMultiplerSet = Set(1, 2, 4, 8, 16, 32, 64, 128, 256)
  require(
    dataWidthMultiplerSet(DATA_WIDTH_MULIPLER),
    "DATA_WIDTH_MULIPLER is not valid"
  )

  val CMD_UNSELECTED = B"4'b1000"
  val CMD_NOP = B"4'b0111"
  val CMD_ACTIVE = B"4'b0011"
  val CMD_READ = B"4'b0101"
  val CMD_WRITE = B"4'b0100"
  val CMD_BURST_TERMINATE = B"4'b0110"
  val CMD_PRECHARGE = B"4'b0010"
  val CMD_REFRESH = B"4'b0001"
  val CMD_LOAD_MODE_REG = B"4'b0000"

  val DQM_ALL_VALID = B(0, l.bytePerWord bits) // 2'b00
  val DQM_ALL_INVALID = ~DQM_ALL_VALID // High means invalid
  val DQM_READ_DELAY_CYCLES = 2

  val MODE_VALUE =
    U"6'b000_0_00" @@ U(c.CAS, 3 bits) @@ U"4'b0_111" // sequential full page
  val ALL_BANK_ADDR = 1 << 10

  val io = new Bundle {
    val axi = slave(Axi4(c.axiConfig))
    val sdram = master(SdramInterface(l)) // setAsReg
    val initDone = out Bool

    axi.addAttribute(name = "IOB", value = "TRUE")
    sdram.addAttribute(name = "IOB", value = "TRUE")
    initDone.addAttribute(name = "IOB", value = "TRUE")
  }
  val awFifo = StreamFifo(Axi4Aw(c.axiConfig), c.bufDepth)
  val wFifo = StreamFifo(Axi4W(c.axiConfig), c.bufDepth)
  val bFifo = StreamFifo(Axi4B(c.axiConfig), c.bufDepth)
  val arFifo = StreamFifo(Axi4Ar(c.axiConfig), c.bufDepth)
  val rFifo = StreamFifo(Axi4R(c.axiConfig), c.bufDepth)
  awFifo.io.push << io.axi.aw
  wFifo.io.push << io.axi.w
  io.axi.b << bFifo.io.pop
  arFifo.io.push << io.axi.ar
  io.axi.r << rFifo.io.pop

  val commandReg = Reg(Bits(4 bits)) init (0)
  val addressReg = Reg(UInt(l.chipAddressWidth bits)) init (0)
  val bankAddrReg = Reg(UInt(l.bankWidth bits)) init (0)
  val burstLenReg = Reg(UInt(c.burstLenWidth bits)) init (0)
  val columnAddrReg = Reg(UInt(l.columnWidth bits)) init (0)
  val busReadDataReg = Reg(Bits(c.busDataWidth bits)) init (0)
  val busReadDataVldReg = Reg(Bool) init (False)
  val busReadDataLastReg = Reg(Bool) init (False)
  val opIdReg = Reg(UInt(c.idWidth bits)) init (0)
  val strobeReg = Reg(Bits(c.busByteSize bits)) init (0)
  val busWriteDataReg = Reg(Bits(c.busDataWidth bits)) init (0)
  val busDataShiftCnt =
    Reg(UInt((log2Up(DATA_WIDTH_MULIPLER) + 1) bits)) init (0)

  val writeMask = strobeReg((l.bytePerWord - 1) downto 0)
  val busWrite = busWriteDataReg((l.dataWidth - 1) downto 0)
  val mask = Bits(l.bytePerWord bits)

  awFifo.io.pop.ready := False
  wFifo.io.pop.ready := False
  bFifo.io.push.valid := False
  arFifo.io.pop.ready := False

  bFifo.io.push.payload.id := opIdReg
  bFifo.io.push.payload.setOKAY()
  rFifo.io.push.payload.data := busReadDataReg
  rFifo.io.push.payload.id := opIdReg
  rFifo.io.push.payload.last := busReadDataLastReg
  rFifo.io.push.payload.setOKAY()
  rFifo.io.push.valid := busReadDataVldReg

  io.sdram.BA := bankAddrReg.asBits
  io.sdram.ADDR := addressReg.asBits
  io.sdram.DQM := mask
  io.sdram.CKE := True
  io.sdram.CSn := commandReg(3)
  io.sdram.RASn := commandReg(2)
  io.sdram.CASn := commandReg(1)
  io.sdram.WEn := commandReg(0)
  io.sdram.DQ.write := busWrite //wFifo.io.pop.payload.data
  io.initDone := False

  commandReg := CMD_NOP
  busReadDataLastReg := False

  assert(
    assertion = (columnAddrReg < l.columnSize - c.burstLen),
    message = "invalid column address and burst length",
    severity = ERROR
  )
  assert(
    assertion =
      awFifo.io.pop.payload.isINCR() && arFifo.io.pop.payload.isINCR(),
    message = "only burst type INCR allowed",
    severity = ERROR
  )
  assert(
    assertion = awFifo.io.pop.payload.len < (256 >> DATA_WIDTH_MULIPLER),
    message = s"burst length should be less than 256/${DATA_WIDTH_MULIPLER}",
    severity = ERROR
  )

  val clkFrequancy = ClockDomain.current.frequency.getValue
  def timeToCycles(time: TimeNumber): BigInt =
    (clkFrequancy * time).setScale(0, RoundingMode.UP).toBigInt

  def cycleCounter(cycleMax: BigInt) = new Area {
    val counter = Reg(UInt(log2Up(cycleMax) bits)) init (0)
    val busy = counter =/= 0
    if (cycleMax > 1) {
      when(busy) {
        counter := counter - 1
      }
    }
    def setCycles(cycles: BigInt) = {
      assert(
        cycles <= cycleMax && cycles > 0,
        s"invalid counter cycle=${cycles}, cycleMax=${cycleMax}"
      )
      counter := cycles - 1
    }
    def setCycles(cycles: UInt) = {
      assert(
        cycles <= cycleMax && cycles > 0,
        s"invalid counter cycle=${cycles}, cycleMax=${cycleMax}"
      )
      counter := (cycles - 1).resized
    }
    def setTime(time: TimeNumber) = setCycles(
      timeToCycles(time).max(1)
    ) // Minimum 1 cycles
  }
  def timeCounter(timeMax: TimeNumber) = cycleCounter(timeToCycles(timeMax))

  val initCounter = timeCounter(t.tPOW)
  val stateCounter = timeCounter(
    t.tRFC
  ) // tRFC is the largest delay except tPOW and tREF
  val refreshCounter = CounterFreeRun(timeToCycles(t.tREF / (1 << l.rowWidth)))

  val initPeriod = Bool
  val refreshReqReg = Reg(Bool) init (False)
  val preReqIsWriteReg = Reg(Bool) init (False)
  val readReq =
    arFifo.io.pop.valid && arFifo.io.pop.payload.len <= rFifo.io.availability
  val writeReq =
    awFifo.io.pop.valid && awFifo.io.pop.payload.len <= wFifo.io.occupancy && bFifo.io.availability > 0

  val initFsm = new StateMachine {
    val INIT_WAIT: State = new State with EntryPoint {
      onEntry {
        initCounter.setTime(t.tPOW)
      } whenIsActive {
        when(!initCounter.busy) {
          goto(INIT_PRECHARGE)
        }
      }
    }

    val INIT_PRECHARGE: State = new State {
      onEntry {
        addressReg := ALL_BANK_ADDR
        commandReg := CMD_PRECHARGE
        stateCounter.setTime(t.tRP)
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(INIT_REFRESH_1)
        }
      }
    }

    val INIT_REFRESH_1: State = new State {
      onEntry {
        commandReg := CMD_REFRESH
        stateCounter.setTime(t.tRFC)
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(INIT_REFRESH_2)
        }
      }
    }

    val INIT_REFRESH_2: State = new State {
      onEntry {
        commandReg := CMD_REFRESH
        stateCounter.setTime(t.tRFC)
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(INIT_LOAD_MODE_REG)
        }
      }
    }

    val INIT_LOAD_MODE_REG: State = new State {
      onEntry {
        addressReg := MODE_VALUE
        commandReg := CMD_LOAD_MODE_REG
        stateCounter.setCycles(t.cMRD)
      } whenIsActive {
        when(!stateCounter.busy) {
          exit()
        }
      }
    }
  }

  val refreshFsm = new StateMachine {
    val REFRESH_PRECHARGE: State = new State with EntryPoint {
      onEntry {
        addressReg := ALL_BANK_ADDR
        commandReg := CMD_REFRESH
        stateCounter.setTime(t.tRP)
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(REFRESH)
        }
      }
    }

    val REFRESH: State = new State {
      onEntry {
        commandReg := CMD_PRECHARGE
        stateCounter.setTime(t.tRFC)
      } whenIsActive {
        when(!stateCounter.busy) {
          exit()
        }
      } onExit {
        refreshReqReg := False
      }
    }
  }

  val writeFsm = new StateMachine {
    val ACTIVE_WRITE: State = new State with EntryPoint {
      onEntry {
        commandReg := CMD_ACTIVE
        bankAddrReg := awFifo.io.pop.payload
          .addr(l.wordAddressWidth - l.bankWidth - 1, l.bankWidth bits)
        addressReg := awFifo.io.pop.payload.addr(
          (l.rowWidth + l.columnWidth - 1) downto l.columnWidth
        ) // Row address
        columnAddrReg := awFifo.io.pop.payload
          .addr((l.columnWidth - 1) downto 0)
          .resized // Colume address
        opIdReg := awFifo.io.pop.payload.id

        burstLenReg := (awFifo.io.pop.payload.len << log2Up(
          DATA_WIDTH_MULIPLER
        )).resized
        stateCounter.setTime(t.tRCD)

        awFifo.io.pop.ready := True // awFifo.io.pop.valid must be true here
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(BURST_WRITE)
        }
      }
    }

    val BURST_WRITE: State = new State {
      onEntry {
        addressReg := columnAddrReg.resized
        commandReg := CMD_WRITE
        stateCounter.setCycles(burstLenReg)

        strobeReg := wFifo.io.pop.payload.strb
        busWriteDataReg := wFifo.io.pop.payload.data
        wFifo.io.pop.ready := True // wFifo.io.pop.valid must be true here
        busDataShiftCnt := DATA_WIDTH_MULIPLER - 1
      } whenIsActive {
        if (DATA_WIDTH_MULIPLER > 1) {
          strobeReg := (strobeReg >> l.bytePerWord).resized
          busWriteDataReg := (busWriteDataReg >> l.dataWidth).resized
          when(busDataShiftCnt > 0) {
            busDataShiftCnt := busDataShiftCnt - 1
          } otherwise {
            strobeReg := wFifo.io.pop.payload.strb
            busWriteDataReg := wFifo.io.pop.payload.data
            wFifo.io.pop.ready := True // wFifo.io.pop.valid must be true here
            busDataShiftCnt := DATA_WIDTH_MULIPLER - 1
          }
        } else {
          busWriteDataReg := wFifo.io.pop.payload.data
          wFifo.io.pop.ready := stateCounter.busy // wFifo.io.pop.valid must be true here
        }

        when(!stateCounter.busy) {
          goto(TERM_WRITE)
        }
      }
    }

    val TERM_WRITE: State = new State {
      onEntry {
        commandReg := CMD_BURST_TERMINATE
      } whenIsActive {
        exit() // Must be one cycle, because AXI4 write response will be sent in this cycle right after burst write finish
      } onExit {
        preReqIsWriteReg := True
        bFifo.io.push.valid := True // bFifo.io.push.ready must be true here
      }
    }
  }

  val readFsm = new StateMachine {
    val ACTIVE: State = new State with EntryPoint {
      onEntry {
        commandReg := CMD_ACTIVE
        bankAddrReg := arFifo.io.pop.payload
          .addr(l.wordAddressWidth - l.bankWidth - 1, l.bankWidth bits)
        addressReg := arFifo.io.pop.payload.addr(
          (l.rowWidth + l.columnWidth - 1) downto l.columnWidth
        ) // Row address
        columnAddrReg := arFifo.io.pop.payload
          .addr((l.columnWidth - 1) downto 0)
          .resized // Colume address
        opIdReg := arFifo.io.pop.payload.id

        burstLenReg := (arFifo.io.pop.payload.len << log2Up(
          DATA_WIDTH_MULIPLER
        )).resized
        stateCounter.setTime(t.tRCD)

        arFifo.io.pop.ready := True // arFifo.io.pop.valid must be true here
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(SEND_READ_CMD)
        }
      }
    }

    val SEND_READ_CMD: State = new State {
      onEntry {
        addressReg := columnAddrReg.resized
        commandReg := CMD_READ
        stateCounter.setCycles(c.CAS)
      } whenIsActive {
        when(!stateCounter.busy) {
          goto(BURST_READ)
        }
      }
    }

    val BURST_READ: State = new State {
      onEntry {
        stateCounter.setCycles(burstLenReg)
      } whenIsActive {
        when(stateCounter.counter === c.CAS) {
          commandReg := CMD_BURST_TERMINATE
        } elsewhen (!stateCounter.busy) {
          exit()
        }
      } onExit {
        preReqIsWriteReg := False
        busReadDataLastReg := True
      }
    }
  }

  val fsm = new StateMachine {
    val INIT: State = new StateFsm(initFsm) with EntryPoint {
      whenCompleted {
        goto(IDLE)
      } onExit {
        io.initDone := True
      }
    }

    val IDLE: State = new State {
      whenIsActive {
        when(refreshReqReg) {
          goto(REFRESH)
        } elsewhen (readReq && writeReq) {
          when(preReqIsWriteReg) {
            goto(READ)
          } otherwise {
            goto(WRITE)
          }
        } elsewhen (writeReq && !readReq) {
          goto(WRITE)
        } elsewhen (readReq && !writeReq) {
          goto(READ)
        }
      }
    }

    val REFRESH: State = new StateFsm(refreshFsm) {
      whenCompleted {
        goto(IDLE)
      }
    }

    val WRITE: State = new StateFsm(writeFsm) {
      whenCompleted {
        goto(PRECHARGE)
      }
    }

    val READ: State = new StateFsm(readFsm) {
      whenCompleted {
        goto(PRECHARGE)
      }
    }

    val PRECHARGE: State = new State {
      onEntry {
        commandReg := CMD_PRECHARGE
      } whenIsActive {
        goto(IDLE)
      }
    }
  }

  // assert(
  //   assertion = writeFsm.isEntering(writeFsm.TERM_WRITE) && wFifo.io.pop.payload.last,
  //   message = "write burst finish requires AXI AWLAST is true",
  //   severity = ERROR
  // )

  initPeriod := fsm.isActive(fsm.INIT)

  when(writeFsm.isActive(writeFsm.BURST_WRITE)) {
    mask := DQM_ALL_VALID | ~writeMask
  } elsewhen (fsm.isActive(fsm.READ)) {
    mask := DQM_ALL_VALID
  } otherwise {
    mask := DQM_ALL_INVALID
  }

  // Handle SDRAM read
  val readArea = new ClockingArea(
    clockDomain = ClockDomain(
      clock = ClockDomain.current.clock,
      reset = ClockDomain.current.reset,
      config = ClockDomainConfig(clockEdge = FALLING)
    )
  ) {
    val readReg = RegNextWhen(io.sdram.DQ.read, io.sdram.DQ.writeEnable === 0)
  }

  val startBurstReadReg = RegNext(readFsm.isEntering(readFsm.BURST_READ))
  if (DATA_WIDTH_MULIPLER > 1) {
    when(startBurstReadReg) {
      busDataShiftCnt := DATA_WIDTH_MULIPLER - 1
    }

    busReadDataVldReg := False
    when(readFsm.isActive(readFsm.BURST_READ)) {
      // Little Endien
      busReadDataReg := readArea.readReg ## busReadDataReg(
        (c.busDataWidth - 1) downto l.dataWidth
      )
      // Big Endien
      // busReadDataReg := busReadDataReg(
      //   (c.busDataWidth - l.dataWidth - 1) downto 0
      // ) ## readArea.readReg
      when(busDataShiftCnt > 0) {
        busDataShiftCnt := busDataShiftCnt - 1
      } otherwise {
        busReadDataVldReg := True
        busDataShiftCnt := DATA_WIDTH_MULIPLER - 1
      }
    }
  } else {
    busReadDataReg := readArea.readReg
    busReadDataVldReg := readFsm.isActive(readFsm.BURST_READ)
  }

  when(!initPeriod && refreshCounter.willOverflow) {
    refreshReqReg := True
  }

  when(writeFsm.isActive(writeFsm.BURST_WRITE)) {
    io.sdram.DQ.writeEnable.setAll()
  } otherwise {
    io.sdram.DQ.writeEnable := 0
  }
}

object SdramController {
  def main(args: Array[String]): Unit = {
    val device = MT48LC16M16A2
    SpinalConfig(defaultClockDomainFrequency = FixedFrequency(100 MHz))
      .generateVerilog(
        new SdramController(
          device.layout,
          device.timingGrade7,
          SdramConfig()
        )
      )
  }
}
