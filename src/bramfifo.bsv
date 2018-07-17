import BRAM::*;
import DefaultValue::*;
import FIFO::*;
import FixedPoint::*;
import constants::*;


interface FIFORand;
	method Action enq(BitSz_20 data, Sizet_20 addr);
	method Action latchData;
	method Action deq(Sizet_20 addr);
    method BitSz_20 get;
endinterface: FIFORand

module mkBuffer#(Integer width)(FIFORand);
	BRAM_Configure cfg = defaultValue;
	cfg.allowWriteResponseBypass = False;
	cfg.memorySize = width;
	cfg.loadFormat = tagged Binary "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/rectangles_array0.txt.mem";

	BRAM2Port#(Sizet_20, BitSz_20) memory <- mkBRAM2Server(cfg);

	Reg#(Sizet_20) rear <- mkReg(0);
	Reg#(Sizet_20) front <- mkReg(0);
	Reg#(BitSz_20) _cache <- mkReg(0);
	Reg#(BitSz_20) _cach2 <- mkReg(0);

	Reg#(int) clk <- mkReg(0);
	Reg#(Bool) _startDeq <- mkReg(False);
	Reg#(Bool) open <- mkReg(False);

	function BRAMRequest#(Sizet_20, BitSz_20) makeRequest(Bool write, Sizet_20  addr, BitSz_20 data);
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


	method Action enq(BitSz_20 data, Sizet_20 addr);
		memory.portA.request.put(makeRequest(True, rear, data));
		if (rear == fromInteger(width)-1)
				rear <= 0; 
		else
			rear <= rear +1;
	endmethod

	
	method Action deq(Sizet_20 addr);
		memory.portB.request.put(makeRequest(False, front, 0));
		if (front == fromInteger(width)-1)
			front <= 0;
		else 
		front <= front+1;
	endmethod


	method BitSz_20 get;
		return _cache;
	endmethod
	
endmodule: mkBuffer
