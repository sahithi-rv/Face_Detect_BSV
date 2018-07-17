import BRAM::*;
import DefaultValue::*;
import FIFO::*;
import constants::*;
import bank_IFC::*;

module mkBankServer#(BRAM2Port#(Sizet_11, BitSz_6) memory, Integer width)(FIFORand2);

        /*BRAM_Configure cfg_bm = defaultValue;
        cfg_bm.allowWriteResponseBypass = False;
        cfg_bm.memorySize = width;
        cfg_bm.loadFormat = tagged Binary "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/bm.mem";
        BRAM2Port#(Sizet_11, BitSz_6) memory <- mkBRAM2Server(cfg_bm);
        */
        Reg#(BitSz_6) _cache <- mkReg(0);
        Reg#(BitSz_6) _cach2 <- mkReg(0);
        Reg#(Sizet_11) rear <- mkReg(0);
        Reg#(Sizet_11) front <- mkReg(0);

        Reg#(int) clk <- mkReg(0);
        Reg#(Bool) _startDeq <- mkReg(False);
        Reg#(Bool) open <- mkReg(False);

        function BRAMRequest#(Sizet_11, BitSz_6) makeRequest(Bool write, Sizet_11  addr, BitSz_6 data);
        return BRAMRequest {
                write : write,
                responseOnWrite : False,
                address : addr,
                datain : data
        };
        endfunction

        method Action latchData;
                let d <- memory.portB.response.get;
                _cache <= d;
        endmethod


        method Action enq(BitSz_6 data);
                memory.portA.request.put(makeRequest(True, rear, data));
                if (rear == fromInteger(width)-1)
                                rear <= 0; 
                else
                        rear <= rear +1;

        endmethod


        method Action deq(Sizet_11 addr);
                memory.portB.request.put(makeRequest(False, addr, 0));
        endmethod


        method BitSz_6 get;
                return _cache;
        endmethod

endmodule
