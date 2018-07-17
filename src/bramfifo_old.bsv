package bramfifo;

import BRAM::*;
import BF_IFC::*;
import constants::*;
import FIFOF::*;

(* synthesize *)
module mkBRAMfifo (BF_ifc);
	
	function BRAMRequest#(BitSz_20, Pixels) makeRequest(Bool write, Bit#(20) addr, Pixels data);
	return BRAMRequest{
		write: write,
		responseOnWrite:False,
		address: addr,
		datain: data
		};
	endfunction

	Reg#(Bool) rreg<- mkReg(False);
	Reg#(Bool) f1reg<- mkReg(False);
	Reg#(Bool) f2reg<- mkReg(False);
	Reg#(Bit#(2)) rreg_A<- mkReg(0);
	Reg#(Bool) rreg_B<- mkReg(False);
	Reg#(BitSz_20) read_addr <- mkReg(0);
	Reg#(Data_32) clk <- mkReg(0);

	FIFOF#(Pixels) deq_reg <- mkSizedFIFOF(1);

	BRAM_Configure cfg = defaultValue;
	cfg.memorySize = valueof(P13);
	String file = "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/rectangles_array0.txt.mem";

	cfg.loadFormat = tagged Binary file;
	BRAM2Port#(BitSz_20, Pixels) fifo <- mkBRAM2Server(cfg);


	rule update_clk;
		clk <= clk + 1;
	endrule

	rule read_fifo_A( !f1reg && !f2reg && (rreg_A == 0) );
		let a <- fifo.portA.response.get;
		deq_reg.enq(a);
		read_addr <= read_addr + 1;
		fifo.portB.request.put(makeRequest(False, read_addr + 1, 0));

		rreg_A <= 1;

	endrule

	rule read_fifo_AB(!f1reg && !f2reg && (rreg_A == 1) );
		let a <- fifo.portB.response.get;
		deq_reg.enq(a);
		read_addr <= read_addr + 1;
		fifo.portA.request.put(makeRequest(False, read_addr + 1, 0));
		rreg_A <= 0;
	endrule

	rule f1(f1reg);
		fifo.portB.request.put(makeRequest(False, read_addr, 0));
		read_addr <= read_addr + 1;
		f1reg <= False;
	endrule

	rule f2(!f1reg && f2reg);
		let a <- fifo.portB.response.get;
		deq_reg.enq(a);
		fifo.portA.request.put(makeRequest(False, read_addr, 0));
		f2reg <= False;
	endrule

	method Action first_req() if (!f1reg );
		f1reg <= True;
	endmethod

	method Action first_res() if( !f2reg );
		f2reg <= True;
	endmethod

	method ActionValue#(Pixels) deq() if (!f1reg &&& !f2reg )  ;

		let a = deq_reg.first;
		deq_reg.deq();
		return a;
	endmethod

endmodule	

endpackage