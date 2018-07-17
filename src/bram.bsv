import BRAM::*;
import DefaultValue::*;
import FIFO::*;
import constants::*;


interface FIFORand;
	method Action enq(Pixels data, Sizet_20 addr);
	method Action latchData;
	method Action deq(Sizet_20 addr);
        method Pixels get;
endinterface: FIFORand


module mkBramServer#(Integer width)(FIFORand);
	BRAM_Configure cfg = defaultValue;
	cfg.allowWriteResponseBypass = False;
	cfg.memorySize = width;
	cfg.loadFormat = tagged Binary "/home/sahithi/fpga/vj_pipeline/mem_files/init_lbuffer.mem";
	BRAM2Port#(Sizet_20, Pixels) memory <- mkBRAM2Server(cfg);
	
	Reg#(Pixels) _cache <- mkReg(0);
	Reg#(Pixels) _cach2 <- mkReg(0);

	Reg#(int) clk <- mkReg(0);
	Reg#(Bool) _startDeq <- mkReg(False);
	Reg#(Bool) open <- mkReg(False);

	function BRAMRequest#(Sizet_20, Pixels) makeRequest(Bool write, Sizet_20  addr, Pixels data);
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


	method Action enq(Pixels data, Sizet_20 addr);
			memory.portA.request.put(makeRequest(True, addr, data));
	endmethod

	
	method Action deq(Sizet_20 addr);
		memory.portB.request.put(makeRequest(False, addr, 0));
	endmethod


	method Pixels get;
		return _cache;
	endmethod
	
endmodule: mkBramServer
