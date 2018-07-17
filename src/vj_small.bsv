package vj_small;

import IFC::*;
import FIFOF::*;
import constants::*;
import Vector :: * ;
import RegFile::*;
import bram::*;

Sizet_20 r = fromInteger(valueof(IMGR));
Sizet_20 c = fromInteger(valueof(IMGC));
Sizet_20 sz = fromInteger(valueof(WSZ));
Data_32 n_stages=fromInteger(valueof(STAGES));

Integer hf = valueof(P13);

(*synthesize*)
module mkVJsmall( VJ_ifc );

	Reg#(Data_32) clk <- mkReg(0);

	Reg#(Sizet_20) row <- mkReg(0);
	Reg#(Sizet_20) col <- mkReg(0);

	Reg#(Bool) init <- mkReg(True);

	FIFOF#(Pixels) input_fifo <- mkSizedFIFOF(100);
	FIFOF#(Pixels) output_fifo <- mkSizedFIFOF(100);

	FIFOF#(PipeLine) lbuffer_fifo <- mkSizedFIFOF(100);
	FIFOF#(PipeLine) iwb_fifo <- mkSizedFIFOF(100);
	FIFOF#(PipeLine) iiwb_fifo <- mkSizedFIFOF(100);
	FIFOF#(PipeLine) lbuffer1_fifo <- mkSizedFIFOF(100);
	FIFOF#(PipeLine) lbuffer2_fifo <- mkSizedFIFOF(100);
	FIFOF#(PipeLine) lbuffer3_fifo <- mkSizedFIFOF(100);

	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) iwb <- replicateM(replicateM(mkReg(0)));
	Vector#(WSZ, Vector#(WSZ, Reg#(Pixels) )) ii <- replicateM(replicateM(mkReg(0)));
	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) siwb <- replicateM(replicateM(mkReg(0)));
	Vector#(WSZ, Vector#(WSZ, Reg#(Pixels) )) sii <- replicateM(replicateM(mkReg(0)));

	Vector#(TSub#(WSZ,1),  FIFORand ) lbuffer <- replicateM(mkBramServer(valueof(P5))) ; 

	Vector#(TSub#(WSZ,1),  Reg#(Pixels)) tempRegs <- replicateM(mkReg(0));

	rule init_ii(init);
		for( Sizet_20 u = 0;u<sz; u=u+1)
		begin
			for(Sizet_20 v = 0;v<sz;v = v+1)
			begin
				ii[u][v] <= 0;
			end
		end

		sii[0][0] <= 0;sii[0][1] <= 0;sii[1][0] <= 0;sii[1][1] <= 0;

		for( Sizet_20 i = 0;i<sz;i = i+1)
		begin
			for( Sizet_20 j = 0;j<2*sz;j = j+1)
			begin
				iwb[i][j] <= 0;
				siwb[i][j] <= 0;
 			end
		end

		init <= False;
	endrule

	rule update_clk(!init );
		clk <= clk + 1;
	endrule

	rule update_ii(!init );

		PipeLine p;
		p.row = row;
		p.col = col;
		p.valid = True;
		p.px = input_fifo.first;
		input_fifo.deq();

	//	$display("ii clk: %d row: %d col: %d px: %d ", clk, p.row, p.col, p.px);

		for( Sizet_20 u = 0;u<sz; u=u+1)
		begin
			for(Sizet_20 v = 0;v<sz;v = v+1)
			begin
				ii[u][v] <= ii[u][v] + ( iwb[u][v+1] - iwb[u][0] );
				$write("%d ", ii[u][v]);
			end
			$display("");
		end
		$display("");

		sii[0][0] <= sii[0][0] + ( siwb[0][1] - siwb[0][0] );
	    sii[0][1] <= sii[0][1] + ( siwb[0][sz] - siwb[0][0] );
	    sii[1][0] <= sii[1][0] + ( siwb[sz-1][1] - siwb[sz-1][0] );
	    sii[1][1] <= sii[1][1] + ( siwb[sz-1][sz] - siwb[sz-1][0] );

		if( col == (c-1))
		begin
			col <= 0;
			row <= row +1;
		end
		else
		begin 
			col <= col + 1;
		end
	
		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].deq(col);
		end


	lbuffer2_fifo.enq(p);

	endrule

	rule latch_data(!init);
		let p = lbuffer2_fifo.first;
		lbuffer2_fifo.deq();

		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].latchData;
		end

		lbuffer3_fifo.enq(p);
	endrule

	rule update_i(!init);

		let p = lbuffer3_fifo.first;
		lbuffer3_fifo.deq();

		let x = p.col;
		let y = p.row;
		let px = p.px;

		for( Sizet_20 j = 0;j<2*sz-1;j = j+1)
		begin
			for( Sizet_20 i = 0;i<sz;i = i+1)
			begin
	          if( (i+j) != (2*sz-1) )
	          begin
	            iwb[i][j] <= iwb[i][j+1];
	            siwb[i][j] <= siwb[i][j+1];
	          end
	          else if ( i > 0 )
	          begin
	            iwb[i][j] <= iwb[i][j+1] + iwb[i-1][j+1];
	            siwb[i][j] <= siwb[i][j+1] + siwb[i-1][j+1];
	          end
			end
		end

		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			let d = lbuffer[i].get;
			tempRegs[i] <= d;
			iwb[i][2*sz-1] <= d;
        	siwb[i][2*sz-1] <= d*d;
		end
		iwb[sz-1][2*sz-1] <= px;
      	siwb[sz-1][2*sz-1] <= px*px;

		iwb_fifo.enq(p);

	endrule

	rule write_lbuffer (!init);

		let p = iwb_fifo.first;
		iwb_fifo.deq();

		Sizet_20 cl = p.col; 
		for(Sizet_20 i = 0; i < (sz-2); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].enq( tempRegs[i+1], cl );
		end
		lbuffer[sz-2].enq(p.px, cl );

		output_fifo.enq(p.px);

	endrule

	/*	rule get_data(!init);
		let p = lbuffer3_fifo.first;
		lbuffer3_fifo.deq();

		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			let d = lbuffer[i].get;
			tempRegs[i] <= d;
		end

		output_fifo.enq(p.px);
	endrule
*/


	method Action read_inp(Pixels px);
		input_fifo.enq(px);
	endmethod

	method ActionValue#(Pixels) result();
		let a = output_fifo.first;
		output_fifo.deq();
		return a;
	endmethod

endmodule

endpackage

