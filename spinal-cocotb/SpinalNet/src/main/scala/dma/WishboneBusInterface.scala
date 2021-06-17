package dma

import spinal.core._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.bus.regif.{BusIf, ClassName}
import spinal.lib.bus.wishbone.Wishbone

case class WishboneBusInterface(
    bus: Wishbone,
    sizeMap: SizeMapping,
    selId: Int = 0,
    readSync: Boolean = true,
    regPre: String = ""
)(implicit moduleName: ClassName)
    extends BusIf {
  override def getModuleName = moduleName.name

  val readError = Bool()
  val readData = Bits(bus.config.dataWidth bits)

  if (readSync) {
    readError.setAsReg() init False
    readData.setAsReg() init 0
  } else {
    readError := False
    readData := 0
  }

  bus.ACK := True
  bus.DAT_MISO := readData
  if (bus.config.useERR) bus.ERR := readError

  val selMatch = if (bus.config.useSEL) bus.SEL(selId) else True
  val askWrite = (selMatch && bus.CYC && bus.STB && bus.WE).allowPruning()
  val askRead = (selMatch && bus.CYC && bus.STB && !bus.WE).allowPruning()
  val doWrite =
    (selMatch && bus.CYC && bus.STB && bus.ACK && bus.WE).allowPruning()
  val doRead =
    (selMatch && bus.CYC && bus.STB && bus.ACK && !bus.WE).allowPruning()
  val writeData = bus.DAT_MISO

  override def readAddress() = bus.ADR
  override def writeAddress() = bus.ADR

  override def readHalt() = bus.ACK := False
  override def writeHalt() = bus.ACK := False

  override def busDataWidth = bus.config.dataWidth
}

object BusInterface {
  def apply(bus: Wishbone, sizeMap: SizeMapping)(implicit
      moduleName: ClassName
  ): BusIf = WishboneBusInterface(bus, sizeMap)(moduleName)
  def apply(bus: Wishbone, sizeMap: SizeMapping, selID: Int)(implicit
      moduleName: ClassName
  ): BusIf = WishboneBusInterface(bus, sizeMap, selID)(moduleName)
  def apply(bus: Wishbone, sizeMap: SizeMapping, selID: Int, regPre: String)(
      implicit moduleName: ClassName
  ): BusIf =
    WishboneBusInterface(bus, sizeMap, selID, regPre = regPre)(moduleName)
  def apply(bus: Wishbone, sizeMap: SizeMapping, selID: Int, readSync: Boolean)(
      implicit moduleName: ClassName
  ): BusIf = WishboneBusInterface(bus, sizeMap, selID, readSync)(moduleName)
  def apply(
      bus: Wishbone,
      sizeMap: SizeMapping,
      selID: Int,
      readSync: Boolean,
      regPre: String
  )(implicit moduleName: ClassName): BusIf =
    WishboneBusInterface(bus, sizeMap, selID, readSync, regPre = regPre)(
      moduleName
    )

//  def apply(bus: Apb3, sizeMap: SizeMapping, selID: Int)(implicit moduleName: ClassName): BusIf = Apb3BusInterface(bus, sizeMap, selID)(moduleName)
//  def apply(bus: Apb3, sizeMap: SizeMapping, selID: Int, regPre: String)(implicit moduleName: ClassName): BusIf = Apb3BusInterface(bus, sizeMap, selID, regPre = regPre)(moduleName)
//  def apply(bus: Apb3, sizeMap: SizeMapping, selID: Int, readSync: Boolean)(implicit moduleName: ClassName): BusIf = Apb3BusInterface(bus, sizeMap, selID, readSync)(moduleName)
//  def apply(bus: Apb3, sizeMap: SizeMapping, selID: Int, readSync: Boolean, regPre: String)(implicit moduleName: ClassName): BusIf = Apb3BusInterface(bus, sizeMap, selID, readSync, regPre = regPre)(moduleName)

//  def apply(bus: AhbLite3, sizeMap: SizeMapping)(implicit moduleName: ClassName): BusIf = AhbLite3BusInterface(bus, sizeMap)(moduleName)
//  def apply(bus: AhbLite3, sizeMap: SizeMapping, regPre: String)(implicit moduleName: ClassName): BusIf = AhbLite3BusInterface(bus, sizeMap, regPre = regPre)(moduleName)
//  def apply(bus: AhbLite3, sizeMap: SizeMapping, readSync: Boolean)(implicit moduleName: ClassName): BusIf = AhbLite3BusInterface(bus, sizeMap, readSync)(moduleName)
//  def apply(bus: AhbLite3, sizeMap: SizeMapping, readSync: Boolean, regPre: String)(implicit moduleName: ClassName): BusIf = AhbLite3BusInterface(bus, sizeMap, readSync, regPre = regPre)(moduleName)

//  def apply(bus: Axi4, sizeMap: SizeMapping): BusIf = Axi4BusInterface(bus, sizeMap)
//  def apply(bus: Axi4, sizeMap: SizeMapping, readSync: Boolean): BusIf = Axi4BusInterface(bus, sizeMap)
//
//  def apply(bus: AxiLite4, sizeMap: SizeMapping): BusIf = AxiLite4BusInterface(bus, sizeMap)
//  def apply(bus: AxiLite4, sizeMap: SizeMapping, readSync: Boolean): BusIf = AxiLite4BusInterface(bus, sizeMap)
}
