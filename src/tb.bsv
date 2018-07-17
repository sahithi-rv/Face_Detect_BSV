package tb;

import constants::*;
import bramfifo::*;
import BF_IFC::*;

(* synthesize *)
module mkTb(Empty);
	
	BF_ifc bf <- mkBRAMfifo;

	Reg#(Bool) init1 <- mkReg(True);
	Reg#(Bool) init2 <- mkReg(False);
	Reg#(Int#(32)) clk <- mkReg(0);


	rule update_clk;
		clk <= clk + 1;
		$display("clk in tb %d", clk);
	endrule

	rule first(init1);
		bf.first_req();

		init1 <= False;
		init2 <= True;
	endrule

	rule sec(!init1 && init2);
		bf.first_res();

		init2 <= False;
	endrule

	rule read_data(!init1 && !init2 && clk >= 3 && clk <= 10);
		let a <- bf.deq();
		let b = unpack(a);
		$display("%d clk: %d", b, clk );
	endrule

	rule done (clk >10);
		$finish(0);
	endrule 

endmodule

endpackage
