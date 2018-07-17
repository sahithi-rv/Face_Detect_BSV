import BRAM::*;
import DefaultValue::*;
import FIFO::*;
import constants::*;
import BF_IFC_20::*;


module mkBramfifoR8#( BRAM2Port#(Sizet_20, BitSz_11) memory, Integer width)(BF_ifc20);
        /*BRAM_Configure cfg = defaultValue;
	cfg.allowWriteResponseBypass = False;
	cfg.memorySize = width;
	cfg.loadFormat = tagged Binary "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/rectangles_array8.txt.mem";
        BRAM2Port#(Sizet_20, BitSz_11) memory <- mkBRAM2Server(cfg);
        */
	Reg#(Sizet_20) rear <- mkReg(0);
	Reg#(Sizet_20) front <- mkReg(0);
        Reg#(BitSz_11) _cache <- mkReg(0);
        Reg#(BitSz_11) _cach2 <- mkReg(0);

	Reg#(int) clk <- mkReg(0);
	Reg#(Bool) _startDeq <- mkReg(False);
	Reg#(Bool) open <- mkReg(False);

        function BRAMRequest#(Sizet_20, BitSz_11) makeRequest(Bool write, Sizet_20  addr, BitSz_11 data);
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
        method Action reset;
            rear <=0;
            front <= 0;
        endmethod

        method Action enq(BitSz_11 data);
		memory.portA.request.put(makeRequest(True, rear, data));
		if (rear == fromInteger(width)-1)
				rear <= 0; 
		else
			rear <= rear +1;
	endmethod

	method Action deq;
		memory.portB.request.put(makeRequest(False, front, 0));
		if (front == fromInteger(width)-1)
			front <= 0;
		else 
		front <= front+1;	
	endmethod


        method BitSz_11 get;
		return _cache;
	endmethod
	
endmodule: mkBramfifoR8
