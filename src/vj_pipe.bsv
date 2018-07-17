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
import utility::*;
import BRAM::*;
import DefaultValue::*;

import bram::*;	//lbuffer
//import bramfifo_ii::*; //img

import bank_IFC::*;
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

import bankram::*;
import offram::*;

import bramfifo_alpha1::*;
import bramfifo_alpha2::*;

import bramfifo_w2::*;
import bramfifo_w3::*;

import bramfifo_wcthresh::*;

Sizet_20 r = fromInteger(valueof(IMGR));
Sizet_20 c = fromInteger(valueof(IMGC));
Sizet_20 sz = fromInteger(valueof(WSZ));
Data_32 n_stages=fromInteger(valueof(STAGES));
Sizet_6 sz1 = fromInteger(valueof(WSZ));
Sizet_11 sz2 = fromInteger(valueof(WSZ));
Sizet_20 init_time = fromInteger(valueof(INIT_TIME));


(*synthesize*)
module mkVJpipe( VJ_ifc );


        Reg#(Data_32) clk <- mkReg(0);

    	Reg#(Sizet_20) row <- mkReg(0);
    	Reg#(Sizet_20) col <- mkReg(0);

        Reg#(Bool) init <- mkReg(False);
        Reg#(Bool) init_bram <- mkReg(True);

        Reg#(Bit#(2)) done_flag <- mkReg(0);

        FIFOF#(Pixels) input_fifo <- mkSizedFIFOF(100);
        FIFOF#(BitSz_20) output_fifor <- mkSizedFIFOF(100);
        FIFOF#(BitSz_20) output_fifoc <- mkSizedFIFOF(100);

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
        FIFOF#(Int#(2)) std_fifo1 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) std_fifo2 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) std_fifo3 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) std_fifo4 <- mkSizedFIFOF(2);
        FIFOF#(Coords) bfifo <- mkSizedFIFOF(2);
        FIFOF#(Coords) bfifo0 <- mkSizedFIFOF(2);
        FIFOF#(Coords) bfifos <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) bfifo1 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) bfifo2 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) bfifo3 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) bfifo4 <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) dummy_fifo <- mkSizedFIFOF(2);
        FIFOF#(PipeLine) dummy_fifo5 <- mkSizedFIFOF(2);

        FIFOF#(Coords) coords_fifo <- mkSizedFIFOF(2);
        FIFOF#(Rects) rects_fifo <- mkSizedFIFOF(2);

    	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) iwb <- replicateM(replicateM(mkReg(0)));
    	Vector#(WSZ, Vector#(WSZ, Reg#(Pixels) )) ii <- replicateM(replicateM(mkReg(0)));
    	Vector#(WSZ, Vector#(TMul#(WSZ,2), Reg#(Pixels) )) siwb <- replicateM(replicateM(mkReg(0)));
    	Vector#(2, Vector#(2, Reg#(Pixels) )) sii <- replicateM(replicateM(mkReg(0)));

        Vector#(TSub#(WSZ,1),  FIFORand ) lbuffer <- replicateM(mkBramServer(valueof(P8))) ;

        BRAM_Configure cfg = defaultValue;
        cfg.allowWriteResponseBypass = False;
        cfg.memorySize = valueof(P12);

        BRAM2Port#(Sizet_20, BitSz_11) rect0 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect1 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect2 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect3 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect4 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect5 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect6 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect7 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect8 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect9 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect10 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, BitSz_11) rect11 <- mkBRAM2Server(cfg);

        BRAM2Port#(Sizet_20, Pixels) br_alpha1 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, Pixels) br_alpha2 <- mkBRAM2Server(cfg);

        BRAM2Port#(Sizet_20, Pixels) br_w2 <- mkBRAM2Server(cfg);
        BRAM2Port#(Sizet_20, Pixels) br_w3 <- mkBRAM2Server(cfg);

        BRAM2Port#(Sizet_20, Pixels) br_wct <- mkBRAM2Server(cfg);


        BF_ifc20 rect_array0 <- mkBramfifoR0(rect0, valueof(P12));
        BF_ifc20 rect_array1 <- mkBramfifoR1(rect1, valueof(P12));
        BF_ifc20 rect_array2 <- mkBramfifoR2(rect2, valueof(P12));
        BF_ifc20 rect_array3 <- mkBramfifoR3(rect3, valueof(P12));

        BF_ifc20 rect_array4 <- mkBramfifoR4(rect4, valueof(P12));
        BF_ifc20 rect_array5 <- mkBramfifoR5(rect5, valueof(P12));
        BF_ifc20 rect_array6 <- mkBramfifoR6(rect6, valueof(P12));
        BF_ifc20 rect_array7 <- mkBramfifoR7(rect7, valueof(P12));

        BF_ifc20 rect_array8 <- mkBramfifoR8(rect8, valueof(P12));
        BF_ifc20 rect_array9 <- mkBramfifoR9(rect9, valueof(P12));
        BF_ifc20 rect_array10 <- mkBramfifoR10(rect10, valueof(P12));
        BF_ifc20 rect_array11 <- mkBramfifoR11(rect11, valueof(P12));

        BF_ifc alpha1 <- mkBramfifoA1(br_alpha1, valueof(P12));
        BF_ifc alpha2 <- mkBramfifoA2(br_alpha2, valueof(P12));

        BF_ifc weights2 <- mkBramfifoW2(br_w2, valueof(P12));
        BF_ifc weights3 <- mkBramfifoW3(br_w3, valueof(P12));

        BF_ifc wc_thresh <- mkBramfifoWT(br_wct, valueof(P12));

        Reg#(UData_32) stddev <- mkReg(0);
        Reg#(Data_32) stddev0 <- mkReg(0);
        Reg#(Data_32) stage_sum <- mkReg(0);
    	Reg#(Data_32) classifier_sum <- mkReg(0);
    	Reg#(Sizet_20) haar_counter <- mkReg(0);
    	Reg#(Data_32) cur_stage <- mkReg(0);
    	Reg#(Sizet_20) element_counter <- mkReg(0);

    	Reg#(Sizet_20) curr_state <- mkReg(0);

    	Vector#( TAdd#(STAGES,1), Reg#(Sizet_20)) stages_array <- replicateM(mkReg(0));
    	Vector#( STAGES, Reg#(Data_32)) stage_thresh  <- replicateM(mkReg(0));

    	Vector#(TSub#(WSZ,1),  Reg#(Pixels)) tempRegs <- replicateM(mkReg(0));
        Vector#(N_BANKS,  Reg#(BitSz_6)) offset_for_banks <- replicateM(mkReg(0));
        Vector#(N_BANKS,  Reg#(Pixels)) data_from_banks <- replicateM(mkReg(0));
        Vector#(4, Vector#(N_COORDS,  Reg#(BitSz_6))) banks <- replicateM(replicateM(mkReg(0)));
        Vector#(4, Vector#(4,  Reg#(Bool))) enable3 <- replicateM(replicateM(mkReg(False)));

        Vector#(N_COORDS,  Reg#(BitSz_6)) offsets <- replicateM(mkReg(0));

        Vector#(WSZ, Vector#(WSZ, Reg#(BitSz_6) )) bm <- replicateM(replicateM(mkReg(0)));
        Vector#(WSZ, Vector#(WSZ, Reg#(BitSz_6) )) om <- replicateM(replicateM(mkReg(0)));

        BRAM_Configure cfg_bm = defaultValue;
        cfg_bm.allowWriteResponseBypass = False;
        cfg_bm.memorySize = valueof(P10);
        //cfg_bm.loadFormat = tagged Binary "/home/sahithi_rvs/Desktop/fpga/vj_pipeline/mem_files/bm.mem";
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm0 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm1 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm2 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm3 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm4 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm5 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm6 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm7 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm8 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm9 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm10 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_bm11 <- mkBRAM2Server(cfg_bm);


        FIFORand2 bm0 <- mkBankServer(mem_bm0, valueof(P10)-1);
        FIFORand2 bm1 <- mkBankServer(mem_bm1, valueof(P10)-1);
        FIFORand2 bm2 <- mkBankServer(mem_bm2, valueof(P10)-1);
        FIFORand2 bm3 <- mkBankServer(mem_bm3, valueof(P10)-1);
        FIFORand2 bm4 <- mkBankServer(mem_bm4, valueof(P10)-1);
        FIFORand2 bm5 <- mkBankServer(mem_bm5, valueof(P10)-1);
        FIFORand2 bm6 <- mkBankServer(mem_bm6, valueof(P10)-1);
        FIFORand2 bm7 <- mkBankServer(mem_bm7, valueof(P10)-1);
        FIFORand2 bm8 <- mkBankServer(mem_bm8, valueof(P10)-1);
        FIFORand2 bm9 <- mkBankServer(mem_bm9, valueof(P10)-1);
        FIFORand2 bm10 <- mkBankServer(mem_bm10, valueof(P10)-1);
        FIFORand2 bm11 <- mkBankServer(mem_bm11, valueof(P10)-1);

        BRAM2Port#(Sizet_11, BitSz_6) mem_om0 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om1 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om2 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om3 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om4 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om5 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om6 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om7 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om8 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om9 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om10 <- mkBRAM2Server(cfg_bm);
        BRAM2Port#(Sizet_11, BitSz_6) mem_om11 <- mkBRAM2Server(cfg_bm);

        FIFORand2 om0 <- mkOffServer(mem_om0, valueof(P10)-1);
        FIFORand2 om1 <- mkOffServer(mem_om1, valueof(P10)-1);
        FIFORand2 om2 <- mkOffServer(mem_om2, valueof(P10)-1);
        FIFORand2 om3 <- mkOffServer(mem_om3, valueof(P10)-1);
        FIFORand2 om4 <- mkOffServer(mem_om4, valueof(P10)-1);
        FIFORand2 om5 <- mkOffServer(mem_om5, valueof(P10)-1);
        FIFORand2 om6 <- mkOffServer(mem_om6, valueof(P10)-1);
        FIFORand2 om7 <- mkOffServer(mem_om7, valueof(P10)-1);
        FIFORand2 om8 <- mkOffServer(mem_om8, valueof(P10)-1);
        FIFORand2 om9 <- mkOffServer(mem_om9, valueof(P10)-1);
        FIFORand2 om10 <- mkOffServer(mem_om10, valueof(P10)-1);
        FIFORand2 om11 <- mkOffServer(mem_om11, valueof(P10)-1);

        // 0-3 : r0- r3
        // 4-7 : r4-r7
        // 8-11 : r8 - r11
        // 12 - 15: a1, a2, w2, w3
        // 16 - 19 : b0 - b3
        // 20 - 23: b4-b7
        // 24- 27 : b8-b11
        // 28 - 31 : o0 - o3
        // 32 - 35 : 04 - 07
        // 36 - 39 : o8 - o11
        // 40 - 43 : wct, 0 ,0,0

        Vector#(44, FIFOF#(Pixels) ) bram_init_fifo <- replicateM(mkSizedFIFOF(45));


        Reg#(Sizet_11) cnt <- mkReg(4);
        Reg#(Sizet_20) index <- mkReg(0);
        Reg#(Sizet_20) iterations <- mkReg(0);
        Reg#(Sizet_11) ind0 <- mkReg(0);
        Reg#(Sizet_20) qaz <- mkReg(0);

        rule initbr_counter(init_bram && !init  && (iterations<init_time) );

            ind0 <= cnt;


            if (cnt == 40)
            begin
                cnt <= 0;
                index <= index +1;
            end
            else
            begin
                cnt <= cnt + 4;
            end

            iterations <= iterations + 1;
        endrule

        rule donebr_counter (init_bram && !init  && iterations >= init_time);
            init_bram <= False;
            init <= True;
            $display("done bram");
        endrule

        rule write_br_r0 (init_bram && !init  );
            let data = bram_init_fifo[0].first;
            bram_init_fifo[0].deq();

            BitSz_11 x = truncate(data);

            rect_array0.enq(x);
        endrule

        rule write_br_r1 (init_bram && !init );
            let data = bram_init_fifo[1].first;
            bram_init_fifo[1].deq();

            BitSz_11 x = truncate(data);

            rect_array1.enq(x);
        endrule

        rule write_br_r2 (init_bram && !init );
            let data = bram_init_fifo[2].first;
            bram_init_fifo[2].deq();
            BitSz_11 x = truncate(data);

            rect_array2.enq(x);
        endrule

        rule write_br_r3 (init_bram && !init );
            let data = bram_init_fifo[3].first;
            bram_init_fifo[3].deq();

            BitSz_11 x = truncate(data);

            rect_array3.enq(x);
        endrule

        rule write_br_r4 (init_bram && !init );
            let data = bram_init_fifo[4].first;
            bram_init_fifo[4].deq();

            BitSz_11 x = truncate(data);

            rect_array4.enq(x);
        endrule

        rule write_br_r5 (init_bram && !init );
            let data = bram_init_fifo[5].first;
            bram_init_fifo[5].deq();

            BitSz_11 x = truncate(data);

            rect_array5.enq(x);
        endrule

        rule write_br_r6 (init_bram && !init );
            let data = bram_init_fifo[6].first;
            bram_init_fifo[6].deq();

            BitSz_11 x = truncate(data);

            rect_array6.enq(x);
        endrule

        rule write_br_r7 (init_bram && !init );
            let data = bram_init_fifo[7].first;
            bram_init_fifo[7].deq();
            BitSz_11 x = truncate(data);

            rect_array7.enq(x);
        endrule

        rule write_br_r8 (init_bram && !init );
            let data = bram_init_fifo[8].first;
            bram_init_fifo[8].deq();

            BitSz_11 x = truncate(data);

            rect_array8.enq(x);
        endrule

        rule write_br_r9 (init_bram && !init );
            let data = bram_init_fifo[9].first;
            bram_init_fifo[9].deq();

            BitSz_11 x = truncate(data);

            rect_array9.enq(x);
        endrule

        rule write_br_r10 (init_bram && !init );
            let data = bram_init_fifo[10].first;
            bram_init_fifo[10].deq();

            BitSz_11 x = truncate(data);

            rect_array10.enq(x);
        endrule

        rule write_br_r11 (init_bram && !init );
            let data = bram_init_fifo[11].first;
            bram_init_fifo[11].deq();
            BitSz_11 x = truncate(data);

            rect_array11.enq(x);
        endrule

        rule write_br_a1 (init_bram && !init );
            let data = bram_init_fifo[12].first;
            bram_init_fifo[12].deq();


            alpha1.enq(data);
        endrule

        rule write_br_a2 (init_bram && !init );
            let data = bram_init_fifo[13].first;
            bram_init_fifo[13].deq();


            alpha2.enq(data);
        endrule

        rule write_br_w2 (init_bram && !init );
            let data = bram_init_fifo[14].first;
            bram_init_fifo[14].deq();

            weights2.enq(data);
        endrule

        rule write_br_w3 (init_bram && !init );
            let data = bram_init_fifo[15].first;
            bram_init_fifo[15].deq();

            weights3.enq(data);
        endrule

        rule write_br_bm0 (init_bram && !init );
            let data = bram_init_fifo[16].first;
            bram_init_fifo[16].deq();

            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm0.enq(x);
            end
        endrule

        rule write_br_bm1 (init_bram && !init );
            let data = bram_init_fifo[17].first;
            bram_init_fifo[17].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm1.enq(x);
            end
        endrule

        rule write_br_bm2 (init_bram && !init );
            let data = bram_init_fifo[18].first;
            bram_init_fifo[18].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm2.enq(x);
            end
        endrule

        rule write_br_bm3 (init_bram && !init );
            let data = bram_init_fifo[19].first;
            bram_init_fifo[19].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm3.enq(x);
            end
        endrule

        rule write_br_bm4 (init_bram && !init );
            let data = bram_init_fifo[20].first;
            bram_init_fifo[20].deq();

            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm4.enq(x);
            end
        endrule

        rule write_br_bm5 (init_bram && !init );
            let data = bram_init_fifo[21].first;
            bram_init_fifo[21].deq();
            
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm5.enq(x);
            end
        endrule

        rule write_br_bm6 (init_bram && !init );
            let data = bram_init_fifo[22].first;
            bram_init_fifo[22].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm6.enq(x);
            end
        endrule

        rule write_br_bm7 (init_bram && !init );
            let data = bram_init_fifo[23].first;
            bram_init_fifo[23].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm7.enq(x);
            end
        endrule

        rule write_br_bm8 (init_bram && !init );
            let data = bram_init_fifo[24].first;
            bram_init_fifo[24].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm8.enq(x);
            end
        endrule

        rule write_br_bm9 (init_bram && !init );
            let data = bram_init_fifo[25].first;
            bram_init_fifo[25].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm9.enq(x);
            end
        endrule

        rule write_br_bm10 (init_bram && !init );
            let data = bram_init_fifo[26].first;
            bram_init_fifo[26].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm10.enq(x);
            end
        endrule

        rule write_br_bm11 (init_bram && !init );
            let data = bram_init_fifo[27].first;
            bram_init_fifo[27].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                bm11.enq(x);
            end
        endrule

        rule write_br_om0 (init_bram && !init );
            let data = bram_init_fifo[28].first;
            bram_init_fifo[28].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om0.enq(x);
            end
        endrule

        rule write_br_om1 (init_bram && !init );
            let data = bram_init_fifo[29].first;
            bram_init_fifo[29].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om1.enq(x);
            end
        endrule

        rule write_br_om2 (init_bram && !init );
            let data = bram_init_fifo[30].first;
            bram_init_fifo[30].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om2.enq(x);
            end
        endrule

        rule write_br_om3 (init_bram && !init );
            let data = bram_init_fifo[31].first;
            bram_init_fifo[31].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om3.enq(x);
            end
        endrule

        rule write_br_om4 (init_bram && !init );
            let data = bram_init_fifo[32].first;
            bram_init_fifo[32].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om4.enq(x);
            end
        endrule

        rule write_br_om5 (init_bram && !init );
            let data = bram_init_fifo[33].first;
            bram_init_fifo[33].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om5.enq(x);
            end
        endrule

        rule write_br_om6 (init_bram && !init );
            let data = bram_init_fifo[34].first;
            bram_init_fifo[34].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om6.enq(x);
            end
        endrule

        rule write_br_om7 (init_bram && !init );
            let data = bram_init_fifo[35].first;
            bram_init_fifo[35].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om7.enq(x);
            end
        endrule

        rule write_br_om8 (init_bram && !init );
            let data = bram_init_fifo[36].first;
            bram_init_fifo[36].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om8.enq(x);
            end
        endrule

        rule write_br_om9 (init_bram && !init );
            let data = bram_init_fifo[37].first;
            bram_init_fifo[37].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om9.enq(x);
            end
        endrule

        rule write_br_om10 (init_bram && !init );
            let data = bram_init_fifo[38].first;
            bram_init_fifo[38].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om10.enq(x);
            end
        endrule

        rule write_br_om11 (init_bram && !init );
            let data = bram_init_fifo[39].first;
            bram_init_fifo[39].deq();
            if (index<626)
            begin
                BitSz_6 x = truncate(data);

                om11.enq(x);
            end
        endrule

        rule write_br_wct (init_bram && !init );
            let data = bram_init_fifo[40].first;
            bram_init_fifo[40].deq();

            wc_thresh.enq(data);
        endrule

        rule justdeq(init_bram && !init );
            bram_init_fifo[43].deq();
            bram_init_fifo[41].deq();
            bram_init_fifo[42].deq();

        endrule

    rule init_ii(init && !init_bram);
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

    rule update_clk(!init && !init_bram);
		clk <= clk + 1;
	endrule


    rule update_ii(!init && !init_bram && curr_state == 0);

//		dummy_fifo4.deq();
		
		PipeLine p;
		p.row = row;
		p.col = col;
        p.px = input_fifo.first;
        input_fifo.deq();
        //p.px = img.get;
    


            $display("ii %d %d %d", row, col, unpack(p.px));

        for( Sizet_20 u = 0; u<sz; u=u+1)
		begin
			for(Sizet_20 v = 0;v<sz;v = v+1)
			begin
				ii[u][v] <= ii[u][v] + ( iwb[u][v+1] - iwb[u][0] );
			end
		end

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

		if(row>30)
		begin
            $finish(0);
		end

		dummy_fifo.enq(p);

	endrule


	rule dummy_rule(!init && !init_bram && curr_state == 0);

		let p = dummy_fifo.first;
		dummy_fifo.deq();

		lbuffer2_fifo.enq(p);

	endrule

    rule latch_data(!init && !init_bram   && curr_state == 0);
		let p = lbuffer2_fifo.first;
		lbuffer2_fifo.deq();

		for(Sizet_20 i = 0; i < (sz-1); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].latchData;
		end

		lbuffer3_fifo.enq(p);
	endrule


    rule update_i(!init && !init_bram   && curr_state == 0 );

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


    rule write_lbuffer(!init && !init_bram   && curr_state == 0 );

               let p = iwb_fifo.first;
               iwb_fifo.deq();


		Sizet_20 cl = p.col; 
		for(Sizet_20 i = 0; i < (sz-2); i = i+1) // wrt to lbuffer
		begin 
			lbuffer[i].enq( tempRegs[i+1], cl );
		end
		lbuffer[sz-2].enq(p.px, cl );

                dummy_fifo5.enq(p);

	endrule

        rule dummy_an(!init && !init_bram   && curr_state == 0);

             let p =  dummy_fifo5.first;
             dummy_fifo5.deq();

             if ( ( (p.row==(sz-1) && p.col>=(2*sz-3)) || (p.row>=sz && (p.col<=(sz-3) || p.col>=(2*sz-3))) ) )
             begin
                 curr_state <= 1;
             end

         endrule


// *********** barrier ************ //

	// stddev
        Reg#(UData_32) interm1 <- mkReg(0);
        Reg#(UData_32) interm2 <- mkReg(0);
        Reg#(UData_32) interm3 <- mkReg(0);
        Reg#(UData_32) dum1 <- mkReg(0);
        Reg#(UData_32) tstddev <- mkReg(0);
        Reg#(UData_32) mean <- mkReg(0);
        Reg#(UData_32) stddev1 <- mkReg(0);
        Reg#(UData_32) stddev2 <- mkReg(0);


    rule compute_stddev(!init && !init_bram && curr_state == 1);

            tstddev <= unpack(sii[0][0] - sii[0][1] - sii[1][0] + sii[1][1]) ;
            $display("stddev %d ", tstddev);

            curr_state <= -1;
	endrule

        rule compute_stddev1(!init && !init_bram && curr_state == -1) ;
            stddev1 <= (tstddev*(24)*(24));
            mean <= unpack(ii[0][0] - ii[0][sz-1] -ii[sz-1][0] + ii[sz-1][sz-1] );

            curr_state <= -2;
        endrule

        rule compute_stddev2 (!init && !init_bram && curr_state == -2);
            stddev <=  stddev1 - mean*mean;

                curr_state <= -3;
        endrule

        rule compute_stddev3(!init && !init_bram && curr_state == -3);

            if( stddev > 0 )
            begin
                interm3 <= 0;
                interm2 <= 0;
                interm1 <= 0;
                dum1 <= 0;
                curr_state<=11;
            end
            else
            begin
                stddev0 <= 1;
                curr_state <= 2;
            end
        endrule



for (Sizet_20 i = 0;i<15;i = i +1)
begin

    rule sq1 (!init && !init_bram && curr_state == (11+i));
        interm3 <= interm3 << 2;
        dum1 <= (stddev >> 30);
        curr_state <= 101 + i;
    endrule


    rule sq2 ( !init && !init_bram && curr_state == 101+i);
        interm3 <= interm3 + dum1;
        stddev <= (stddev<<2);
        interm1 <= (interm1 <<1);
        curr_state <= 151 + i;
    endrule

    rule sq3 (!init && !init_bram && curr_state == 151 + i);
        interm2 <= (interm1 <<1) | 1;
        curr_state <= 201 + i;
    endrule

    rule sq4 (!init && !init_bram && curr_state == 201 + i);
        if ( interm3 >= interm2 )
        begin
          interm3 <= (interm3-interm2);
          interm1 <= interm1 + 1;
        end
        curr_state <= (11+i+1);
    endrule
end

    rule sq1_15 (!init && !init_bram && curr_state == (26));
        interm3 <= interm3 << 2;
        dum1 <= (stddev >> 30);
        curr_state <= 116;
    endrule


    rule sq2_15 (!init && !init_bram &&  curr_state == 116);
        interm3 <= interm3 + dum1;
        stddev <= (stddev<<2);
        interm1 <= (interm1 <<1);
        curr_state <= 166;
    endrule

    rule sq3_15 (!init && !init_bram && curr_state == 166);
        interm2 <= (interm1<<1) | 1;
        curr_state <= 216;
    endrule

    rule sq4_15 (!init && !init_bram && curr_state == 216);
        if ( interm3 >= interm2 )
        begin
          interm3 <= (interm3-interm2);
          interm1 <= interm1 + 1;
        end
        curr_state <= 2000;
    endrule

    rule get_sqrt (!init && !init_bram && curr_state == 2000);
        stddev0 <= unpack(pack(interm1));
        curr_state <= 2;
    endrule

	rule wc_req( !init && !init_bram && curr_state == 2 && stages_array[cur_stage]!=haar_counter );

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

	rule wc_latch(!init && !init_bram &&  curr_state == 2);

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

                dummy_fifo2.enq(1);


	endrule

    rule wc_compute(!init && !init_bram &&  curr_state == 2);
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

                bfifo.enq(p);
	endrule

        rule wc_compute1 (!init && !init_bram && curr_state == 2);
                let p = bfifo.first;
                bfifo.deq();

                let addr1 = p.y1*sz2 + p.x1;
                let addr2 = p.y1*sz2 + (p.x1 + p.w1);
                let addr3 = (p.y1+p.h1)*sz2 + p.x1;
                let addr4 = (p.y1+p.h1)*sz2 + (p.x1 + p.w1);
                let addr5 = p.y2*sz2 + p.x2;
                let addr6 = p.y2*sz2 + (p.x2 + p.w2);
                let addr7 = (p.y2+p.h2)*sz2 + p.x2;
                let addr8 = (p.y2+p.h2)*sz2 + (p.x2 + p.w2);
                let addr9 = p.y3*sz2 + p.x3;
                let addr10 = p.y3*sz2 + (p.x3 + p.w3);
                let addr11 = (p.y3+p.h3)*sz2 + p.x3;
                let addr12 = (p.y3+p.h3)*sz2 + (p.x3 + p.w3);

                //request bank maps and offset maps
                bm0.deq(addr1);
                bm1.deq(addr2);
                bm2.deq(addr3);
                bm3.deq(addr4);
                bm4.deq(addr5);
                bm5.deq(addr6);
                bm6.deq(addr7);
                bm7.deq(addr8);
                bm8.deq(addr9);
                bm9.deq(addr10);
                bm10.deq(addr11);
                bm11.deq(addr12);

                om0.deq(addr1);
                om1.deq(addr2);
                om2.deq(addr3);
                om3.deq(addr4);
                om4.deq(addr5);
                om5.deq(addr6);
                om6.deq(addr7);
                om7.deq(addr8);
                om8.deq(addr9);
                om9.deq(addr10);
                om10.deq(addr11);
                om11.deq(addr12);

                bfifos.enq(p);
        endrule

        rule latch_banks_offsets (!init && !init_bram && curr_state == 2);
            let p = bfifos.first;
            bfifos.deq();

            bm0.latchData;
            bm1.latchData;
            bm2.latchData;
            bm3.latchData;
            bm4.latchData;
            bm5.latchData;
            bm6.latchData;
            bm7.latchData;
            bm8.latchData;
            bm9.latchData;
            bm10.latchData;
            bm11.latchData;

            om0.latchData;
            om1.latchData;
            om2.latchData;
            om3.latchData;
            om4.latchData;
            om5.latchData;
            om6.latchData;
            om7.latchData;
            om8.latchData;
            om9.latchData;
            om10.latchData;
            om11.latchData;


            bfifo0.enq(p);

        endrule

        rule get_banks_offsets (!init && !init_bram && curr_state == 2);
            Banks b;

            Coords p = bfifo0.first;
            bfifo0.deq();
            b.b0 = bm0.get;
            b.b1 = bm1.get;
            b.b2 = bm2.get;
            b.b3 = bm3.get;

            b.b4 = bm4.get;
            b.b5 = bm5.get;
            b.b6 = bm6.get;
            b.b7 = bm7.get;

            banks[0][0] <= b.b0;
            banks[0][1] <= b.b1;
            banks[0][2] <= b.b2;
            banks[0][3] <= b.b3;
            banks[0][4] <= b.b4;
            banks[0][5] <= b.b5;
            banks[0][6] <= b.b6;
            banks[0][7] <= b.b7;

            let offm1 = om0.get;
            let offm2 = om1.get;
            let offm3 = om2.get;
            let offm4 = om3.get;

            let offm5 = om4.get;
            let offm6 = om5.get;
            let offm7 = om6.get;
            let offm8 = om7.get;

            offsets[0] <= offm1;
            offsets[1] <= offm2;
            offsets[2] <= offm3;
            offsets[3] <= offm4;
            offsets[4] <= offm5;
            offsets[5] <= offm6;
            offsets[6] <= offm7;
            offsets[7] <= offm8;

            if (!(p.x3 ==0 && p.w3==0 && p.y3==0 && p.h3==0 ) && p.w3!=0 && p.h3!=0)
            begin
                b.b8 = bm8.get;
                b.b9 = bm9.get;
                b.b10 = bm10.get;
                b.b11 = bm11.get;


                banks[0][8] <= b.b8;
                banks[0][9] <= b.b9;
                banks[0][10] <= b.b10;
                banks[0][11] <= b.b11;

                let offm9 = om8.get;
                let offm10 = om9.get;
                let offm11 = om10.get;
                let offm12 = om11.get;

                offsets[8] <= offm9;
                offsets[9] <= offm10;
                offsets[10] <= offm11;
                offsets[11] <= offm12;

                enable3[0][0] <= True;
                enable3[0][1] <= True;
                enable3[0][2] <= True;
                enable3[0][3] <= True;
            end
            else
            begin

                banks[0][8] <= b.b0;
                banks[0][9] <= b.b1;
                banks[0][10] <= b.b2;
                banks[0][11] <= b.b3;


                offsets[8] <= offm1;
                offsets[9] <= offm2;
                offsets[10] <= offm3;
                offsets[11] <= offm4;

                enable3[0][0] <= False;
                enable3[0][1] <= False;
                enable3[0][2] <= False;
                enable3[0][3] <= False;
            end

            bfifo1.enq(1);

        endrule

        rule wc_set_offset (!init && !init_bram && curr_state == 2);
            //Banks b = bfifo1.first;
            bfifo1.deq();

          // $display("banks: %d %d %d %d",banks[0][0], banks[0][1], banks[0][2], banks[0][3] );
            //$display("banks: %d %d %d %d",banks[0][4], banks[0][5], banks[0][6], banks[0][7] );
            //$display("banks: %d %d %d %d",banks[0][8], banks[0][9], banks[0][10], banks[0][11] );

            //$display("off: %d %d %d %d",offsets[0], offsets[1], offsets[2], offsets[3] );
            //$display("off: %d %d %d %d",offsets[4], offsets[5], offsets[6], offsets[7] );
            //$display("off: %d %d %d %d",offsets[8], offsets[9], offsets[10], offsets[11] );
          
        
            for (BitSz_6 i = 0; i < 28; i = i +1)
            begin
                Pixels a = 0;


                if (banks[0][0] == i)
                begin
                    offset_for_banks[i] <= offsets[0];
                end
                else
                begin
                    if (banks[0][1] == i)
                    begin
                        offset_for_banks[i] <= offsets[1];
                    end
                    else
                    begin
                        if (banks[0][2] == i)
                        begin
                            offset_for_banks[i] <= offsets[2];
                        end
                        else
                        begin
                            if (banks[0][3] == i)
                            begin
                                offset_for_banks[i] <= offsets[3];
                            end
                            else
                            begin
                                if (banks[0][4] == i)
                                begin
                                    offset_for_banks[i] <= offsets[4];
                                end
                                else
                                begin
                                    if (banks[0][5] == i)
                                    begin
                                        offset_for_banks[i] <= offsets[5];
                                    end
                                    else
                                    begin
                                        if (banks[0][6] == i)
                                        begin
                                            offset_for_banks[i] <= offsets[6];
                                        end
                                        else
                                        begin
                                            if (banks[0][7] == i)
                                            begin
                                                offset_for_banks[i] <= offsets[7];
                                            end
                                            else
                                            begin
                                                if (banks[0][8] == i)
                                                begin
                                                    offset_for_banks[i] <= offsets[8];
                                                end
                                                else
                                                begin
                                                    if (banks[0][9] == i)
                                                    begin
                                                        offset_for_banks[i] <= offsets[9];
                                                    end
                                                    else
                                                    begin
                                                        if (banks[0][10] == i)
                                                        begin
                                                            offset_for_banks[i] <= offsets[10];
                                                        end
                                                        else
                                                        begin
                                                            if (banks[0][11] == i)
                                                            begin
                                                                offset_for_banks[i] <= offsets[11];
                                                            end
                                                            else
                                                            begin
                                                                offset_for_banks[i] <= 0;
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

            end

            banks[1][0] <= banks[0][0] ;
            banks[1][1] <= banks[0][1]  ;
            banks[1][2] <= banks[0][2] ;
            banks[1][3] <= banks[0][3] ;
            banks[1][4] <= banks[0][4] ;
            banks[1][5] <= banks[0][5] ;
            banks[1][6] <= banks[0][6] ;
            banks[1][7] <= banks[0][7] ;
            banks[1][8] <= banks[0][8] ;
            banks[1][9] <= banks[0][9] ;
            banks[1][10] <=banks[0][10] ;
            banks[1][11] <= banks[0][11] ;

            enable3[1][0] <= enable3[0][0];
            enable3[1][1] <= enable3[0][1];
            enable3[1][2] <= enable3[0][2];
            enable3[1][3] <= enable3[0][3];

            weights2.deq();
            weights3.deq();

            wc_thresh.deq();
            alpha1.deq();
            alpha2.deq();

            bfifo2.enq(1);

        endrule

        rule get_all_data(!init && !init_bram && curr_state == 2);
            bfifo2.deq();
            Vector#(TMul#(WSZ,WSZ), Pixels ) ii_copy;
            for( Sizet_20 u = 0;u<sz; u=u+1)
            begin
                    for(Sizet_20 v = 0;v<sz;v = v+1)
                    begin
                            let p = u*sz + v;
                            ii_copy[p] = ii[u][v];
                    end
            end

            data_from_banks[0] <= get_data0(offset_for_banks[0], ii_copy);
            data_from_banks[1] <= get_data1(offset_for_banks[1], ii_copy);
            data_from_banks[2] <= get_data2(offset_for_banks[2], ii_copy);
            data_from_banks[3] <= get_data3(offset_for_banks[3], ii_copy);
            data_from_banks[4] <= get_data4(offset_for_banks[4], ii_copy);
            data_from_banks[5] <= get_data5(offset_for_banks[5], ii_copy);
            data_from_banks[6] <= get_data6(offset_for_banks[6], ii_copy);
            data_from_banks[7] <= get_data7(offset_for_banks[7], ii_copy);
            data_from_banks[8] <= get_data8(offset_for_banks[8], ii_copy);
            data_from_banks[9] <= get_data9(offset_for_banks[9], ii_copy);
            data_from_banks[10] <= get_data10(offset_for_banks[10], ii_copy);
            data_from_banks[11] <= get_data11(offset_for_banks[11], ii_copy);
            data_from_banks[12] <= get_data12(offset_for_banks[12], ii_copy);
            data_from_banks[13] <= get_data13(offset_for_banks[13], ii_copy);
            data_from_banks[14] <= get_data14(offset_for_banks[14], ii_copy);
            data_from_banks[15] <= get_data15(offset_for_banks[15], ii_copy);
            data_from_banks[16] <= get_data16(offset_for_banks[16], ii_copy);
            data_from_banks[17] <= get_data17(offset_for_banks[17], ii_copy);
            data_from_banks[18] <= get_data18(offset_for_banks[18], ii_copy);
            data_from_banks[19] <= get_data19(offset_for_banks[19], ii_copy);
            data_from_banks[20] <= get_data20(offset_for_banks[20], ii_copy);
            data_from_banks[21] <= get_data21(offset_for_banks[21], ii_copy);
            data_from_banks[22] <= get_data22(offset_for_banks[22], ii_copy);
            data_from_banks[23] <= get_data23(offset_for_banks[23], ii_copy);
            data_from_banks[24] <= get_data24(offset_for_banks[24], ii_copy);
            data_from_banks[25] <= get_data25(offset_for_banks[25], ii_copy);
            data_from_banks[26] <= get_data26(offset_for_banks[26], ii_copy);
            data_from_banks[27] <= get_data27(offset_for_banks[27], ii_copy);

            banks[2][0] <= banks[1][0] ;
            banks[2][1] <= banks[1][1]  ;
            banks[2][2] <= banks[1][2] ;
            banks[2][3] <= banks[1][3] ;
            banks[2][4] <= banks[1][4] ;
            banks[2][5] <= banks[1][5] ;
            banks[2][6] <= banks[1][6] ;
            banks[2][7] <= banks[1][7] ;
            banks[2][8] <= banks[1][8] ;
            banks[2][9] <= banks[1][9] ;
            banks[2][10] <=banks[1][10] ;
            banks[2][11] <= banks[1][11] ;

            enable3[2][0] <= enable3[1][0];
            enable3[2][1] <= enable3[1][1];
            enable3[2][2] <= enable3[1][2];
            enable3[2][3] <= enable3[1][3];

            //latch
            wc_thresh.latchData;
            alpha1.latchData;
            alpha2.latchData;

            weights2.latchData;
            weights3.latchData;

            bfifo3.enq(1);
        endrule

	rule wc_compute2( !init && !init_bram && curr_state == 2);
                bfifo3.deq();
		Rects rec;
                //let p = coords_fifo.first;
                //coords_fifo.deq();

                let a1 = wc_thresh.get;
                let a2 = alpha1.get;
                let a3 = alpha2.get;

                let w2 = weights2.get;
                let w3 = weights3.get;


                rec.rect1 = unpack(data_from_banks[banks[2][0]]) - unpack(data_from_banks[banks[2][1]]) - unpack(data_from_banks[banks[2][2]]) + unpack(data_from_banks[banks[2][3]]) ;
                rec.rect2 = unpack(data_from_banks[banks[2][4]]) - unpack(data_from_banks[banks[2][5]]) - unpack(data_from_banks[banks[2][6]]) + unpack(data_from_banks[banks[2][7]]) ;

                if (enable3[2][0] && enable3[2][1] && enable3[2][2] && enable3[2][3] )
                begin
                    rec.rect3 = unpack(data_from_banks[banks[2][8]]) - unpack(data_from_banks[banks[2][9]]) - unpack(data_from_banks[banks[2][10]]) + unpack(data_from_banks[banks[2][11]]) ;
                end
                else
                begin
                    rec.rect3 = 0;
                end

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
 
	rule wc_compute3(!init && !init_bram &&  curr_state == 2);

		let r = rects_fifo.first;
		rects_fifo.deq();
      //  $display("w2: %d w3: %d", r.weights2, r.weights3);
		let classifier_sum=r.rect1*(-4096) + r.rect2*r.weights2 + r.rect3*r.weights3;
		hc1 <= hc1 + 1;
                $display("hc %d sum %d",hc1, classifier_sum);
                $display("thresh: %d, stddev0: %d",r.wc_thresh, stddev0);
                if(classifier_sum>=(r.wc_thresh*stddev0) )
		begin
                        //$display("A2");
			stage_sum<=stage_sum+r.alpha2;
		end
		else
		begin
                        //$display("A1");
			stage_sum<=stage_sum+r.alpha1;
		end
              //  $display("");
		if ( stages_array[cur_stage]==hc1 )
		begin
			curr_state <= 3;
		end
        endrule

// ********** barrier ************ //
	rule wc_check ( !init && !init_bram && curr_state == 3  );


                $display("cur_stage %d stagesum %d\n",cur_stage, stage_sum);
		if(stage_sum>stage_thresh[cur_stage]) //continue
		begin
			if( cur_stage == (n_stages-1) )
			begin 

				//face 
               // $display("face detected: %d %d\n",row,col);
				cur_stage <= 0;
				haar_counter <= 0;
				stage_sum <= 0;
				curr_state <= 0;
                output_fifor.enq(pack(row));
                output_fifoc.enq(pack(col));
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
                // $display("next stage");
				cur_stage <= cur_stage + 1;
				stage_sum <= 0;
				curr_state <= 2;
			end
		end
		else 
		begin
             // $display("no face");
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

        method Action  putbram(PCIE_PKT pcie_pkt) if(curr_state == 0 && init_bram);
                Vector #(4, Pixels) raw_data = unpack (pcie_pkt.data);
                bram_init_fifo[ind0].enq(raw_data[0]);
                bram_init_fifo[ind0+1].enq(raw_data[1]);
                bram_init_fifo[ind0+2].enq(raw_data[2]);
                bram_init_fifo[ind0+3].enq(raw_data[3]);
        endmethod
        
        method Action  put(PCIE_PKT pcie_pkt) if(curr_state == 0 && !init && !init_bram );
            
            Vector #(4, Pixels) raw_data = unpack (pcie_pkt.data);
            //$display("%d", unpack(raw_data[3]));
            input_fifo.enq(raw_data[3]);

        endmethod

        method ActionValue#(PCIE_PKT) get();

            let rw = output_fifor.first();
            let cl = output_fifoc.first();
            output_fifor.deq();
            output_fifoc.deq();

            Vector #(4, Pixels) raw_odata = newVector;
            raw_odata[0] = 0;
            raw_odata[1] = 0;
            raw_odata[2] = extend(rw);
            raw_odata[3] = extend(cl);

            PCIE_PKT odata;
            odata.data = pack(raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;
            return odata;
        endmethod        

endmodule

endpackage