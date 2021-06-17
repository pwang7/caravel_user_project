package sdram

import org.scalatest.funsuite.AnyFunSuite

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.com.eth._
import spinal.sim._
import spinal.lib.memory.sdram.SdramLayout
import spinal.lib.memory.sdram.sdr.{MT48LC16M16A2, SdramTimings, SdramInterface}

import testutils.CocotbRunner

case class mt48lc16m16a2(l: SdramLayout) extends BlackBox {
  val io = new Bundle {
    val sdram = slave(SdramInterface(l)).setName("")
  }

  noIoPrefix()
  addRTLPath("./SpinalNet/test/src/verilog/mt48lc16m16a2.v")
}

/*
case class SdramModelPlus(l: SdramLayout) extends BlackBox {
  val io = new Bundle {
    val Dq    = inout Bits(l.dataWidth bits)
    val Addr  = in Bits(l.chipAddressWidth bits)
    val Ba    = in Bits(l.bankWidth bits)
    val Clk   = in Bool
    val Cke   = in Bool
    val Ras_n = in Bool
    val Cas_n = in Bool
    val Cs_n  = in Bool
    val We_n  = in Bool
    val Dqm   = in Bits(l.bytePerWord bits)
    val Debug = in Bool
  }
  mapCurrentClockDomain(io.Clk)
  noIoPrefix()
  addGeneric("addr_bits", l.chipAddressWidth)
  addGeneric("data_bits", l.dataWidth)
  addGeneric("col_bits", l.columnWidth)
  addRTLPath("./SpinalNet/test/src/verilog/SdramModelPlus.v")
}

class SdramControllerTb(l: SdramLayout, t: SdramTimings, c: SdramConfig) extends Component {
  val io = new Bundle {
    val bus = slave(SdramBus(l, c))
  }

  val controller = new SdramController(l, t, c)
  controller.io.bus <> io.bus

  val sdramDevice = SdramModelPlus(l)
  sdramDevice.io.Addr := controller.io.sdram.ADDR
  sdramDevice.io.Ba := controller.io.sdram.BA
  sdramDevice.io.Cke := controller.io.sdram.CKE
  sdramDevice.io.Ras_n := controller.io.sdram.RASn
  sdramDevice.io.Cas_n := controller.io.sdram.CASn
  sdramDevice.io.Cs_n := controller.io.sdram.CSn
  sdramDevice.io.We_n := controller.io.sdram.WEn
  sdramDevice.io.Dqm := controller.io.sdram.DQM
  sdramDevice.io.Debug := True
  when (controller.io.sdram.DQ.writeEnable === 1) {
    sdramDevice.io.Dq := controller.io.sdram.DQ.write
  }
  controller.io.sdram.DQ.read := sdramDevice.io.Dq
  
  // val sdramDevice = mt48lc16m16a2(l)
  // sdramDevice.io.sdram <> controller.io.sdram
}
*/

class SdramControllerTest extends AnyFunSuite {
  val device = MT48LC16M16A2
  val l = device.layout
  val t = device.timingGrade7
  val c = SdramConfig()

  test("sdram test") {
    val compiled = SimConfig
    .withWave
    .withConfig(SpinalConfig(defaultClockDomainFrequency = FixedFrequency(200 MHz)))
    .compile(new SdramController(l, t, c))
    assert(CocotbRunner("./SpinalNet/test/src/python/sdram_controller"), "Simulation faild")
    println("SUCCESS")
  }

/*
  def simTest(dut: SdramControllerTb) {
    SimTimeout(1000)
    dut.clockDomain.forkStimulus(2)

    dut.io.bus.cmd.valid #= true
    dut.io.bus.cmd.address  #= 0
    dut.io.bus.cmd.write    #= true
    dut.io.bus.cmd.data     #= 127
    dut.io.bus.cmd.burstLen #= 1
    dut.io.bus.cmd.mask     #= 3
    dut.io.bus.cmd.opId       #= 1
    dut.io.bus.cmd.last     #= true
    dut.io.bus.rsp.ready #= false
  }

  test("sdram test") {
    SimConfig
    .withWave
    .withConfig(SpinalConfig(defaultClockDomainFrequency = FixedFrequency(100 MHz)))
    .compile(new SdramControllerTb(l, t, c))
    .doSim(simTest(_))
  }
*/
}
