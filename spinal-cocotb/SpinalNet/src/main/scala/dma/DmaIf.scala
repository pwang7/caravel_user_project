package dma

import spinal.core._
import spinal.lib._

//--- control
case class Ctrl() extends Bundle with IMasterSlave {
  val start = Bool
  val busy = Bool
  val done = Bool
  val halt = Bool

  override def asMaster(): Unit = {
    out(start, halt)
    in(busy, done)
  }
}

case class Param(addressWidth: Int, xySizeWidth: Int)
    extends Bundle
    with IMasterSlave {
  val sar = UInt(addressWidth bits) // source byte addr
  val dar = UInt(addressWidth bits) // destination byte addr
  val xsize = UInt(
    xySizeWidth bits
  ) // 2D DMA x-dir transfer byte size, cnt from 0
  val ysize = UInt(xySizeWidth bits) // 2D DMA y-dir transfer lines, cnt fom 0
  val srcystep = UInt(
    xySizeWidth bits
  ) // source byte addr offset between each line, cnt from 1
  val dstystep = UInt(
    xySizeWidth bits
  ) // destination byte addr offset between each line, cnt from 1
  val llr = UInt(
    addressWidth bits
  ) // DMA cmd linked list base addr (addr pointer)
  val bf = Bool // bufferable flag in AXI cmd
  val cf = Bool // cacheable flag in AXI cmd

  override def asMaster(): Unit = {
    out(
      sar,
      dar,
      xsize,
      ysize,
      srcystep,
      dstystep,
      llr,
      bf,
      cf
    )
  }
}
