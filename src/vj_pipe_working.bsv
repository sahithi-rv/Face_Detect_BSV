package vj_pipe;

/**
	0 -> window buffer updation
	1 -> stddev
	2 -> compute haar feature
**/

import IFC::*;
import FIFOF::*;
import constants::*;
import Vector :: * ;
import BF_IFC::*;
import BF_IFC_20::*;
import RegFile::*;

import bram::*;	//lbuffer
import bramfifo_ii::*; //img

import bramfifo_r0::*;
import bramfifo_r1::*;
import bramfifo_r2::*;
import bramfifo_r3::*;
import bramfifo_r4::*;
import bramfifo_r5::*;
import bramfifo_r6::*;
import bramfifo_r7::*;
import bramfifo_r8::*;
import bramfifo_r9::*;
import bramfifo_r10::*;
import bramfifo_r11::*;

import bramfifo_alpha1::*;
import bramfifo_alpha2::*;

import bramfifo_w2::*;
import bramfifo_w3::*;

import bramfifo_wcthresh::*;

Sizet_20 r = fromInteger(valueof(IMGR));
Sizet_20 c = fromInteger(valueof(IMGC));
Sizet_20 sz = fromInteger(valueof(WSZ));
Sizet_20 wt = fromInteger(valueof(WT));
Data_32 n_stages=fromInteger(valueof(STAGES));

Integer hf = valueof(P13);

(*synthesize*)
module mkVJpipe( VJ_ifc );

	Reg#(Data_32) clk <- mkReg(0);

	Reg#(Sizet_20) row <- mkReg(0);
	Reg#(Sizet_20) col <- mkReg(0);

	Reg#(Bool) init <- mkReg(True);

        Reg#(Bit#(2)) done_flag <- mkReg(0);

        FIFOF#(Pixels) input_fifo <- mkSizedFIFOF(100);
        FIFOF#(BitSz_20) output_fifo <- mkSizedFIFOF(100);

        FIFOF#(PipeLine) lbuffer_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) iwb_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) iiwb_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) lbuffer1_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) lbuffer2_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) lbuffer3_fifo <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) dummy_fifo1 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) dummy_fifo2 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) dummy_fifo3 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) dummy_fifo4 <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) dummy_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) dummy_fifo5 <- mkSizedFIFOF(2);

        FIFOF#(Coords) coords_fifo <- mkSizedFIFOF(2);
        FIFOF#(Rects) rects_fifo <- mkSizedFIFOF(2);

	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) iwb <- replicateM(replicateM(mkReg(0)));
	Vector#(WSZ, Vector#(WSZ, Reg#(Pixels) )) ii <- replicateM(replicateM(mkReg(0)));
	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) siwb <- replicateM(replicateM(mkReg(0)));
	Vector#(2, Vector#(2, Reg#(Pixels) )) sii <- replicateM(replicateM(mkReg(0)));

        Vector#(TSub#(WSZ,1),  FIFORand ) lbuffer <- replicateM(mkBramServer(valueof(P8))) ;

	BF_ifc20 rect_array0 <- mkBramfifoR0(valueof(P12));
	BF_ifc20 rect_array1 <- mkBramfifoR1(valueof(P12));
	BF_ifc20 rect_array2 <- mkBramfifoR2(valueof(P12));
	BF_ifc20 rect_array3 <- mkBramfifoR3(valueof(P12));

	BF_ifc20 rect_array4 <- mkBramfifoR4(valueof(P12));
	BF_ifc20 rect_array5 <- mkBramfifoR5(valueof(P12));
	BF_ifc20 rect_array6 <- mkBramfifoR6(valueof(P12));
	BF_ifc20 rect_array7 <- mkBramfifoR7(valueof(P12));

	BF_ifc20 rect_array8 <- mkBramfifoR8(valueof(P12));
	BF_ifc20 rect_array9 <- mkBramfifoR9(valueof(P12));
	BF_ifc20 rect_array10 <- mkBramfifoR10(valueof(P12));
	BF_ifc20 rect_array11 <- mkBramfifoR11(valueof(P12));

	BF_ifc alpha1 <- mkBramfifoA1(valueof(P12));
	BF_ifc alpha2 <- mkBramfifoA2(valueof(P12));

        BF_ifc weights2 <- mkBramfifoW2(valueof(P12));
        BF_ifc weights3 <- mkBramfifoW3(valueof(P12));

	BF_ifc wc_thresh <- mkBramfifoWT(valueof(P12));

        BF_ifc img <- mkBramFifoII((valueof(P16)) );
        //BF_ifc img <- mkBramFifoII(64 );

	Reg#(Data_32) stddev <- mkReg(0);
	Reg#(Data_32) stage_sum <- mkReg(0);
	Reg#(Data_32) classifier_sum <- mkReg(0);
	Reg#(Sizet_20) haar_counter <- mkReg(0);
	Reg#(Data_32) cur_stage <- mkReg(0);
	Reg#(Sizet_20) element_counter <- mkReg(0);

	Reg#(Sizet_20) curr_state <- mkReg(0);

	Vector#( TAdd#(STAGES,1), Reg#(Sizet_20)) stages_array <- replicateM(mkReg(0));
	Vector#( STAGES, Reg#(Data_32)) stage_thresh  <- replicateM(mkReg(0));

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
	
		stages_array[0] <= 9;
		stages_array[1] <= 25;
		stages_array[2] <= 52;
		stages_array[3] <= 84;
		stages_array[4] <= 136;
		stages_array[5] <= 189;
		stages_array[6] <= 251;
		stages_array[7] <= 323;
		stages_array[8] <= 406;
		stages_array[9] <= 497;
		stages_array[10] <= 596;
		stages_array[11] <= 711;
		stages_array[12] <= 838;
		stages_array[13] <= 973;
		stages_array[14] <= 1109;
		stages_array[15] <= 1246;
		stages_array[16] <= 1405;
		stages_array[17] <= 1560;
		stages_array[18] <= 1729;
		stages_array[19] <= 1925;
		stages_array[20] <= 2122;
		stages_array[21] <= 2303;
		stages_array[22] <= 2502;
		stages_array[23] <= 2713;
		stages_array[24] <= 2913;

		stage_thresh[0] <= -516;
		stage_thresh[1] <= -510;
		stage_thresh[2] <= -477;
		stage_thresh[3] <= -456;
		stage_thresh[4] <= -449;
		stage_thresh[5] <= -423;
		stage_thresh[6] <= -412;
		stage_thresh[7] <= -398;
		stage_thresh[8] <= -394;
		stage_thresh[9] <= -374;
		stage_thresh[10] <=-396;
		stage_thresh[11] <=-381;
		stage_thresh[12] <=-365;
		stage_thresh[13] <=-379;
		stage_thresh[14] <=-351;
		stage_thresh[15] <=-360;
		stage_thresh[16] <=-368;
		stage_thresh[17] <=-348;
		stage_thresh[18] <=-332;
		stage_thresh[19] <=-329;
		stage_thresh[20] <=-336;
		stage_thresh[21] <=-340;
		stage_thresh[22] <=-334;
		stage_thresh[23] <=-345;
		stage_thresh[24] <= -307;

		init <= False;

	endrule

	rule update_clk(!init);
		clk <= clk + 1;
	endrule



        rule img_req(!init  && curr_state == 0);
		img.deq();
		dummy_fifo3.enq(1);
	endrule

	rule img_latch(!init  && curr_state == 0);
		let p = dummy_fifo3.first;
		dummy_fifo3.deq();
		img.latchData;
		dummy_fifo4.enq(p);
	endrule

        rule update_ii(!init && curr_state == 0);

		dummy_fifo4.deq();
		
		PipeLine p;
		p.row = row;
		p.col = col;
	//	p.px = input_fifo.first;
	//	input_fifo.deq();
		p.px = img.get;
               /* if (row>=24)
                begin
                    $display("ii clk: %d row: %d col: %d px: %d\n ", clk, p.row, p.col, p.px);
                end*/

                for( Sizet_20 u = 0; u<sz; u=u+1)
		begin
			for(Sizet_20 v = 0;v<sz;v = v+1)
			begin
				ii[u][v] <= ii[u][v] + ( iwb[u][v+1] - iwb[u][0] );
			end
		end

            /*    for( Sizet_20 u = 0; u<sz; u=u+1)
                begin
                        for(Sizet_20 v = 0;v<sz;v = v+1)
                        begin
                                $write("%d", unpack(ii[u][v]) );
                        end
                        $display("");
                end
                $display("");*/

		sii[0][0] <= sii[0][0] + ( siwb[0][1] - siwb[0][0] );
                sii[0][1] <= sii[0][1] + ( siwb[0][sz] - siwb[0][0] );
                sii[1][0] <= sii[1][0] + ( siwb[sz-1][1] - siwb[sz-1][0] );
                sii[1][1] <= sii[1][1] + ( siwb[sz-1][sz] - siwb[sz-1][0] );


		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].deq(col);
		end

		if( col == (c-1))
		begin
			col <= 0;
			row <= row +1;
		end
		else
		begin 
			col <= col + 1;
		end

		if(row>r)
		begin
                        done_flag <= 1;
		end

		dummy_fifo.enq(p);

	endrule


	rule dummy_rule(curr_state == 0);

		let p = dummy_fifo.first;
		dummy_fifo.deq();

		lbuffer2_fifo.enq(p);

	endrule

        rule latch_data(!init && curr_state == 0);
		let p = lbuffer2_fifo.first;
		lbuffer2_fifo.deq();

		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].latchData;
		end

		lbuffer3_fifo.enq(p);
	endrule


        rule update_i(!init && curr_state == 0 );

                let p = lbuffer3_fifo.first;
                lbuffer3_fifo.deq();
                //let p =  dummy_fifo5.first;
                //dummy_fifo5.deq();
		let x = p.col;
		let y = p.row;
		let px = p.px;
                //$display("update i clk: %d row: %d col: %d px: %d\n ", clk, p.row, p.col, p.px);

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

            /*    for( Sizet_20 i = 0;i<sz;i = i+1)
			begin
                        for( Sizet_20 j = 0;j<2*sz;j = j+1)
                                begin
                                        $write("%d ", iwb[i][j]);
                                end
                                $display("");
                        end

		$display("");
              */
                iwb_fifo.enq(p);

	endrule


        rule write_lbuffer(!init && curr_state == 0 );

               // let p =  dummy_fifo5.first;
               // dummy_fifo5.deq();
               let p = iwb_fifo.first;
               iwb_fifo.deq();

            //    $display("write lbuffer  clk: %d row: %d col: %d \n ", clk, p.row, p.col);

		Sizet_20 cl = p.col; 
		for(Sizet_20 i = 0; i < (sz-2); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].enq( tempRegs[i+1], cl );
		end
		lbuffer[sz-2].enq(p.px, cl );

                dummy_fifo5.enq(p);

	endrule

        rule dummy_an(!init && curr_state == 0);
             //let p =lbuffer3_fifo.first;
             //lbuffer3_fifo.deq();
             let p =  dummy_fifo5.first;
             dummy_fifo5.deq();
            // $display("dummy an clk: %d row: %d col: %d px: %d\n ", clk, p.row, p.col, p.px);

             if ( ( (p.row==(sz-1) && p.col>=(2*sz-3)) || (p.row>=sz && (p.col<=(sz-3) || p.col>=(2*sz-3))) ) )
             begin
                 curr_state <= 1;
             end

         endrule


// *********** barrier ************ //

	// stddev
        Reg#(Data_32) result_reg <- mkReg(0);
	Reg#(Data_32) reg_sq <- mkReg(0);
	Reg#(Data_32) reg_sqrt <- mkReg(0);
	Reg#(Data_32) reg_ans <- mkReg(0);
	Reg#(Data_32) reg_i <- mkReg(0);

        rule compute_stddev(curr_state == 1);

                Data_32 tstddev = unpack(sii[0][0] - sii[0][1] - sii[1][0] + sii[1][1]) ;
               // $display("%d %d %d %d", ii[0][0], ii[0][sz-1], ii[sz-1][0], ii[sz-1][sz-1]);
                //$display("%d %d %d %d", sii[0][0], sii[0][1], sii[1][0], sii[1][1]);
                Data_32 mean = unpack(ii[0][0] - ii[0][sz-1] -ii[sz-1][0] + ii[sz-1][sz-1] );
               // $display("stddev: %d, mean: %d", tstddev, mean);

                let stddev1 = (tstddev*(24)*(24));
  		let stddev2 =  stddev1 - mean*mean; 
                //$display("std %d",stddev2);
  		reg_sq <= stddev2;
  		let stddev3 = 1;
  		if( stddev2 > 0 )
		begin
                     curr_state<=11;
                     //curr_state<=0;
		end
                else
		begin
		    stddev <= 1;
                    curr_state <= 2;
                    //curr_state <= 0;
		end
	endrule

       rule init_sqrt(curr_state == 11 );

		if( reg_sq == 0 )
		begin
			
			stddev <= 0;
			curr_state <= 2;
		end
		else
		begin
			if( reg_sq == 1 )
			begin
				stddev <= 1;
				curr_state <= 2;
			end
			else
			begin
				result_reg <= 1;
				reg_ans <= 0;
				reg_i <= 1;
				curr_state <= 12;
			end
		end
	endrule

	rule while_sqrt( curr_state == 12 );
		let a = reg_i;
		reg_ans <= a;
		reg_i <= a + 1;
		result_reg <=  (a+1)*(a+1);
		curr_state <= 13;
	endrule

	rule check_sqrt( curr_state == 13  );
		if( result_reg < reg_sq )
		begin
			curr_state <= 12;
		end
		else 
		begin
			if( result_reg == reg_sq && !(done_flag == 1))
			begin
				stddev <= reg_i;
				curr_state <= 2;
		//		$display("stddev %d", reg_i);
			end
			else
			begin
				stddev <= reg_ans;
				curr_state <= 2;
			//	$display("stddev %d", reg_ans);
			end
		end
	endrule

	rule wc_req( curr_state == 2 && stages_array[cur_stage]!=haar_counter );

               // $display("wc_req");
		rect_array0.deq();
		rect_array1.deq();
		rect_array2.deq();
		rect_array3.deq();

		rect_array4.deq();
		rect_array5.deq();
		rect_array6.deq();
		rect_array7.deq();

		rect_array8.deq();
		rect_array9.deq();
		rect_array10.deq();
		rect_array11.deq();

		dummy_fifo1.enq(1);

		haar_counter <= haar_counter + 1;

	endrule

	rule wc_latch( curr_state == 2);

		dummy_fifo1.deq();
		rect_array0.latchData;
		rect_array1.latchData;
		rect_array2.latchData;
		rect_array3.latchData;
		rect_array4.latchData;
		rect_array5.latchData;
		rect_array6.latchData;
		rect_array7.latchData;
		rect_array8.latchData;
		rect_array9.latchData;
		rect_array10.latchData;
		rect_array11.latchData;


		weights2.deq();
		weights3.deq();

		dummy_fifo2.enq(1);

		//deq
		wc_thresh.deq();
		alpha1.deq();
		alpha2.deq();

	endrule

	rule wc_compute1( curr_state == 2);
		dummy_fifo2.deq();
		Coords p;
		let a1 = rect_array0.get;
		let a2 = rect_array1.get;
		let a3 = rect_array2.get;
		let a4 = rect_array3.get;
		let a5 = rect_array4.get;
		let a6 = rect_array5.get;
		let a7 = rect_array6.get;
		let a8 = rect_array7.get;
		let a9 = rect_array8.get;
		let a10 = rect_array9.get;
		let a11 = rect_array10.get;
		let a12 = rect_array11.get;


		p.x1 = unpack(a1);
		p.y1 = unpack(a2);
		p.w1 = unpack(a3);
		p.h1 = unpack(a4);		
		p.x2 = unpack(a5);
		p.y2 = unpack(a6);
		p.w2 = unpack(a7);
		p.h2 = unpack(a8);		
		p.x3 = unpack(a9);
		p.y3 = unpack(a10);
		p.w3 = unpack(a11);
		p.h3 = unpack(a12);

                //$display("coords: %d %d %d %d", p.x1,p.y1, p.x2, p.x3);

		
		coords_fifo.enq(p);


		//latch 
		wc_thresh.latchData;
		alpha1.latchData;
		alpha2.latchData;


		weights2.latchData;
		weights3.latchData;


	endrule

	rule wc_compute2( curr_state == 2);

		Rects rec;
		let p = coords_fifo.first;
		coords_fifo.deq();

		rec.rect1 = unpack(ii[p.y1][p.x1])-unpack(ii[p.y1+p.h1][p.x1]) - unpack(ii[p.y1][p.x1+p.w1]) + unpack(ii[p.y1+p.h1][p.x1+p.w1]);		
		rec.rect2 = unpack(ii[p.y2][p.x2])-unpack(ii[p.y2+p.h2][p.x2]) - unpack(ii[p.y2][p.x2+p.w2]) + unpack(ii[p.y2+p.h2][p.x2+p.w2]);
		rec.rect3 = unpack(ii[p.y3][p.x3])-unpack(ii[p.y3+p.h3][p.x3]) - unpack(ii[p.y3][p.x3+p.w3]) + unpack(ii[p.y3+p.h3][p.x3+p.w3]);
		let a1 = wc_thresh.get;
		let a2 = alpha1.get;
		let a3 = alpha2.get;

		let w2 = weights2.get;
		let w3 = weights3.get;

		rec.wc_thresh = unpack(a1);
		rec.alpha1 = unpack(a2);
		rec.alpha2 = unpack(a3);

		rec.weights2 = unpack(w2);
		rec.weights3 = unpack(w3);
               // $display("pos: %d %d %d %d", p.y1, p.x1, p.h1, p.w1);
                //$display("coords: %d %d %d %d", ii[p.y1][p.x1], unpack(ii[p.y1+p.h1][p.x1]), unpack(ii[p.y1][p.x1+p.w1]), unpack(ii[p.y1+p.h1][p.x1+p.w1]));
                //$display("r1: %d r2: %d r3: %d",rec.rect1, rec.rect2, rec.rect3);
                //$display("a1: %d, a2: %d, w2: %d, w3: %d, wc_thresh: %d\n", rec.alpha1, rec.alpha2, rec.weights2, rec.weights3, rec.wc_thresh);
		rects_fifo.enq(rec);


	endrule

        Reg#(Sizet_20) hc1 <- mkReg(1);
 
	rule wc_compute3( curr_state == 2);

		let r = rects_fifo.first;
		rects_fifo.deq();
		let classifier_sum=r.rect1*(-4096) + r.rect2*r.weights2 + r.rect3*r.weights3;
		hc1 <= hc1 + 1;
                //$display("hc %d sum %d",hc1, classifier_sum);
                //$display("thresh: %d, stddev: %d",r.wc_thresh, stddev);
		if(classifier_sum>=(r.wc_thresh*stddev) )
		begin
                //        $display("A2");
			stage_sum<=stage_sum+r.alpha2;
		end
		else
		begin
                //        $display("A1");
			stage_sum<=stage_sum+r.alpha1;
		end
                //$display("");
		if ( stages_array[cur_stage]==hc1 )
		begin
			curr_state <= 3;
		end
        endrule

// ********** barrier ************ //
	rule wc_check ( curr_state == 3  );


              //  $display("cur_stage %d stagesum %d\n",cur_stage, stage_sum);
		if(stage_sum>stage_thresh[cur_stage]) //continue
		begin
			if( cur_stage == (n_stages-1) )
			begin 

				//face 
                               // $display("face detected: %d %d\n",row,col);
                                //$finish(0);
				cur_stage <= 0;
				haar_counter <= 0;
				stage_sum <= 0;
				curr_state <= 0;
				let p = pack(row*25+col);
				output_fifo.enq(p);
                                hc1 <= 1;
                                rect_array0.reset;
                                rect_array1.reset;
                                rect_array2.reset;
                                rect_array3.reset;
                                rect_array4.reset;
                                rect_array5.reset;
                                rect_array6.reset;
                                rect_array7.reset;
                                rect_array8.reset;
                                rect_array9.reset;
                                rect_array10.reset;
                                rect_array11.reset;
                                wc_thresh.reset;
                                weights2.reset;
                                weights3.reset;
                                alpha1.reset;
                                alpha2.reset;
			end
			else 
			begin
                   //             $display("next stage");
				cur_stage <= cur_stage + 1;
				stage_sum <= 0;
				curr_state <= 2;
			end
		end
		else 
		begin
                      //  $display("no face");
			curr_state <= 0;
			stage_sum <= 0;
			haar_counter <= 0;
                        cur_stage <= 0;
                        hc1 <= 1;
                        rect_array0.reset;
                        rect_array1.reset;
                        rect_array2.reset;
                        rect_array3.reset;
                        rect_array4.reset;
                        rect_array5.reset;
                        rect_array6.reset;
                        rect_array7.reset;
                        rect_array8.reset;
                        rect_array9.reset;
                        rect_array10.reset;
                        rect_array11.reset;
                        wc_thresh.reset;
                        weights2.reset;
                        weights3.reset;
                        alpha1.reset;
                        alpha2.reset;
		end

        endrule

        /*rule done(done_flag == 1);
		$finish(0);
	endrule
        */

	method Action read_inp(Pixels px);
		input_fifo.enq(px);
	endmethod

	method ActionValue#(BitSz_20) result();
		let a = output_fifo.first;
		output_fifo.deq();
		return a;
	endmethod

        method Bit#(2) isDone if(done_flag == 1);
		return done_flag;
        endmethod

endmodule

endpackage

 /*               for( Sizet_20 u = 0;u<sz; u=u+1)
                begin
                    for(Sizet_20 v = 0;v<sz;v = v+1)
                    begin
                        ii_copy[u][v] <= ii[u][v];

                    end
                end
                sii_copy[0][0] <= sii[0][0];
                sii_copy[0][1] <= sii[0][1];
                sii_copy[1][0] <= sii[1][0];
                sii_copy[1][1] <= sii[1][1];
*/
