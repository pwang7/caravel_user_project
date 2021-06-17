package dma

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
// import spinal.lib.bus.amba4.axi.sim._
import spinal.lib.sim._

import scala.collection.mutable

object DmaControllerSim extends App {
  val dmaConfig = DmaConfig(
    addressWidth = 32,
    burstLen = 8,
    bufDepth = 32,
    dataWidth = 32,
    xySizeMax = 256
  )

  def runDma(
      dut: DmaController,
      axiMem: AxiMemorySim,
      sar: Int,
      dar: Int,
      xsize: Int,
      ysize: Int,
      srcystep: Int,
      dstystep: Int
  ): Unit = {
    val queue = mutable.Queue[Int]()

    dut.io.ctrl.start #= false
    dut.io.ctrl.halt #= false

    dut.io.param.sar #= sar
    dut.io.param.dar #= dar
    dut.io.param.xsize #= xsize // At least bus byte size
    dut.io.param.ysize #= ysize
    dut.io.param.srcystep #= srcystep
    dut.io.param.dstystep #= dstystep
    dut.io.param.llr #= 0
    dut.io.param.bf #= true
    dut.io.param.cf #= true

    sleep(0) // Make io.param assignment effective
    // val axiMem = AxiMemorySim(
    //   dut.io.axi,
    //   dut.clockDomain,
    //   AxiMemorySimConfig(writeResponseDelay = 0)
    // )

    // Prepare memory data
    val srcBeginAddr = dut.io.param.sar.toLong
    val srcRowGap = dut.io.param.xsize.toInt + dut.io.param.srcystep.toInt
    val rowSize = dut.io.param.xsize.toInt
    for (y <- 0 until dut.io.param.ysize.toInt) {
      for (x <- 0 until dut.io.param.xsize.toInt) {
        val inc = y * srcRowGap + x
        val d = (y * rowSize + x) % 128
        val addr = srcBeginAddr + inc

        axiMem.memory.write(addr, d.toByte)
        println(f"prepare: addr=$addr, data=${d}=${d}%x")
        queue.enqueue(d)
      }
    }

    dut.clockDomain.waitSampling(10)
    dut.io.ctrl.start #= true
    axiMem.start()
    dut.clockDomain.waitSampling()
    dut.io.ctrl.start #= false

    waitUntil(dut.io.ctrl.done.toBoolean)
    dut.clockDomain.waitSampling(2)

    val dstBeginAddr = dut.io.param.dar.toLong
    val dstRowGap = dut.io.param.xsize.toInt + dut.io.param.dstystep.toInt
    for (y <- 0 until dut.io.param.ysize.toInt) {
      for (x <- 0 until dut.io.param.xsize.toInt) {
        val inc = y * dstRowGap + x
        val addr = dstBeginAddr + inc

        val b = axiMem.memory.read(addr)
        println(f"check: addr=$addr, data=${b.toInt}=${b.toInt}%x")
        val t = queue.dequeue()
        assert(b.toInt == t, s"${b.toInt}==${t} assert failed")
      }
    }
  }

  SimConfig.withWave
    .compile(new DmaController(dmaConfig))
    .doSim { dut =>
      val axiMem = AxiMemorySim(
        dut.io.axi,
        dut.clockDomain,
        AxiMemorySimConfig(writeResponseDelay = 0)
      )

      dut.clockDomain.forkStimulus(5)

      val sar = 4091
      val dar = 8183
      val xsize = 57 // At least twice bus byte size, minimum burst length is 2
      val ysize = 2
      val srcystep = 5
      val dstystep = 9
      runDma(
        dut,
        axiMem,
        sar,
        dar,
        xsize,
        ysize,
        srcystep,
        dstystep
      )

    // dut.clockDomain.waitSampling(2)
    // sar      = 8183
    // dar      = 4091
    // // xsize    = 57 // At least bus byte size
    // // ysize    = 2
    // // srcystep = 5
    // // dstystep = 9
    // runDma(
    //   dut,
    //   axiMem,
    //   sar,
    //   dar,
    //   xsize,
    //   ysize,
    //   srcystep,
    //   dstystep
    // )
    }
}
