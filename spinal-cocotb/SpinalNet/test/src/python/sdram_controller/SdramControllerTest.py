import cocotb
from cocotb import utils
from cocotb.triggers import Timer, RisingEdge
from cocotblib.misc import simulationSpeedPrinter

async def ClockDomainAsyncResetCustom(clk, reset):
    if reset:
        reset <= 1
    clk <= 0
    await Timer(100000)
    if reset:
        reset <= 0
    while True:
        clk <= 0
        await Timer(3750)
        clk <= 1
        await Timer(3750)

async def waitUntil(clk, cond):
    while True:
        if cond():
            break
        await RisingEdge(clk)

@cocotb.test()
async def testFunc(dut):
    cocotb.fork(ClockDomainAsyncResetCustom(dut.clk, dut.reset))
    cocotb.fork(simulationSpeedPrinter(dut.clk))

    dut.io_axi_aw_valid <= False
    dut.io_axi_w_valid  <= False
    dut.io_axi_b_ready  <= False
    dut.io_axi_ar_valid <= False
    dut.io_axi_r_ready  <= False

    await waitUntil(dut.clk, lambda: int(dut.io_initDone) == 1)
    print("init done at: {}".format(utils.get_sim_time(units='ns')))
    dut.io_axi_b_ready  <= True

    busDataWidth = 32
    sdramDQWidth = 16
    dataWidthMultipler = int(busDataWidth / sdramDQWidth) # AXI burst size in bytes
    strobe = int(pow(2, pow(2, dataWidthMultipler)) - 1)
    burstLen = 4
    rangeMax = 16
    print("bus width = {}, SDRAM DQ width = {}, strobe = {}, burst length = {}".format(
        busDataWidth, sdramDQWidth, strobe, burstLen
    ))

    for i in range(rangeMax):
        dut.io_axi_aw_valid         <= True
        dut.io_axi_aw_payload_addr  <= i * burstLen * dataWidthMultipler
        dut.io_axi_aw_payload_id    <= i
        dut.io_axi_aw_payload_len   <= burstLen
        dut.io_axi_aw_payload_size  <= dataWidthMultipler
        dut.io_axi_aw_payload_burst <= 1 # INCR
        await RisingEdge(dut.clk)
        await waitUntil(dut.clk, lambda: (int(dut.io_axi_aw_valid) == 1 and int(dut.io_axi_aw_ready) == 1))
        dut.io_axi_aw_valid <= False

        for d in range(burstLen):
            dut.io_axi_w_valid        <= True
            dut.io_axi_w_payload_data <= i * burstLen + d
            dut.io_axi_w_payload_strb <= strobe
            dut.io_axi_w_payload_last <= ((d + 1) % burstLen == 0)
            await RisingEdge(dut.clk)
            await waitUntil(dut.clk, lambda: (int(dut.io_axi_w_valid) == 1 and int(dut.io_axi_w_ready) == 1))
            dut.io_axi_w_valid <= False

            print("write: addr={}, data={}, id={}, last={}".format(
                i * burstLen + d,
                int(dut.io_axi_w_payload_data),
                int(dut.io_axi_aw_payload_id),
                int(dut.io_axi_w_payload_last)
            ))

        await waitUntil(dut.clk, lambda: (int(dut.io_axi_b_valid) == 1 and int(dut.io_axi_b_ready) == 1))

    dut.io_axi_b_ready  <= False
    dut.io_axi_r_ready  <= True

    for i in range(rangeMax):
        dut.io_axi_ar_valid         <= True
        dut.io_axi_ar_payload_addr  <= i * burstLen * dataWidthMultipler
        dut.io_axi_ar_payload_id    <= i
        dut.io_axi_ar_payload_len   <= burstLen
        dut.io_axi_ar_payload_size  <= dataWidthMultipler
        dut.io_axi_ar_payload_burst <= 1 # INCR
        await RisingEdge(dut.clk)
        await waitUntil(dut.clk, lambda: (int(dut.io_axi_ar_valid) == 1 and int(dut.io_axi_ar_ready) == 1))
        dut.io_axi_ar_valid <= False

        for d in range(burstLen):
            await RisingEdge(dut.clk)
            await waitUntil(dut.clk, lambda: (int(dut.io_axi_r_valid) == 1 and int(dut.io_axi_r_ready) == 1))

            print("read: addr={}, data={}, id={}, last={}".format(
                (i * burstLen + d),
                int(dut.io_axi_r_payload_data),
                int(dut.io_axi_r_payload_id),
                int(dut.io_axi_r_payload_last)
            ))
            assert int(dut.io_axi_r_payload_data) == (i * burstLen + d), "read data not match"

    dut.io_axi_r_ready  <= False
    print("finished at: {}".format(utils.get_sim_time(units='ns')))
    await RisingEdge(dut.clk)
