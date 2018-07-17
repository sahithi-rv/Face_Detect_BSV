import BRAM::*;
import DefaultValue::*;
import FIFO::*;
import constants::*;
import BF_IFC::*;


module mkBramfifoA1#(BRAM2Port#(Sizet_20, Pixels) memory,Integer width)(BF_ifc);
        /*BRAM_Configure cfg = defaultValue;
	cfg.allowWriteResponseBypass = False;
	cfg.memorySize = width;
	cfg.loadFormat = tagged Binary "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/alpha1_array.txt.mem";
	BRAM2Port#(Sizet_20, Pixels) memory <- mkBRAM2Server(cfg);
        */
	Reg#(Sizet_20) rear <- mkReg(0);
	Reg#(Sizet_20) front <- mkReg(0);
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
        method Action reset;
            rear <=0;
            front <= 0;
        endmethod

	method Action enq(Pixels data);
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


	method Pixels get;
		return _cache;
	endmethod
	
endmodule: mkBramfifoA1
