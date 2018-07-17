package vj_pipe_tb;

import RegFile::*;
import IFC::*;
import constants::*;
import vj_pipe::*;
//import bramfifo_ii::*; //img
import BF_IFC::*;
import FIFOF::*;
import Vector:: *;
import BRAM::*;

import bramfifo_alpha1::*;
import bramfifo_alpha2::*;

import bramfifo_wcthresh::*;


Sizet_20 r = fromInteger(valueof(IMGR));
Sizet_20 c = fromInteger(valueof(IMGC));
Sizet_20 tot_pixels = 2913;
Sizet_20 tot = r*c;
Sizet_20 totmaps = 625;
Sizet_20 stages = 7;
Sizet_20 hf = fromInteger(valueof(HF));

(* synthesize *)
module mkVJpipeTb( Empty );
        //BF_ifc img <- mkBramFifoII((valueof(P16)) );
        RegFile#(Sizet_20, Pixels) rf_r0 <- mkRegFileLoad ("../hex_files/rectangles_array0.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r1 <- mkRegFileLoad ("../hex_files/rectangles_array1.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r2 <- mkRegFileLoad ("../hex_files/rectangles_array2.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r3 <- mkRegFileLoad ("../hex_files/rectangles_array3.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r4 <- mkRegFileLoad ("../hex_files/rectangles_array4.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r5 <- mkRegFileLoad ("../hex_files/rectangles_array5.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r6 <- mkRegFileLoad ("../hex_files/rectangles_array6.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r7 <- mkRegFileLoad ("../hex_files/rectangles_array7.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r8 <- mkRegFileLoad ("../hex_files/rectangles_array8.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r9 <- mkRegFileLoad ("../hex_files/rectangles_array9.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r10 <- mkRegFileLoad ("../hex_files/rectangles_array10.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_r11 <- mkRegFileLoad ("../hex_files/rectangles_array11.hex",0,tot_pixels);

        RegFile#(Sizet_20, Pixels) rf_a1 <- mkRegFileLoad ("../hex_files/alpha1_array.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_a2 <- mkRegFileLoad ("../hex_files/alpha2_array.hex",0,tot_pixels);

        RegFile#(Sizet_20, Pixels) rf_w1 <- mkRegFileLoad ("../hex_files/weights_array1.hex",0,tot_pixels);
        RegFile#(Sizet_20, Pixels) rf_w2 <- mkRegFileLoad ("../hex_files/weights_array2.hex",0,tot_pixels);

        RegFile#(Sizet_20, Pixels) rf_wct <- mkRegFileLoad ("../hex_files/wc_thresh_array.hex",0,tot_pixels);
        
        RegFile#(Sizet_20, Pixels) rf_bm <- mkRegFileLoad ("../hex_files/bmhex.txt",0,totmaps);
        RegFile#(Sizet_20, Pixels) rf_om <- mkRegFileLoad ("../hex_files/omhex.txt",0,totmaps);

        RegFile#(Sizet_20, Pixels) img <- mkRegFileLoad ("../hex_files/imghex185.hex",0,tot);


        Reg#(Sizet_20) clk <- mkReg(0);
        Reg#(Sizet_20) index <- mkReg(0);
        Reg#(Sizet_20) ind <- mkReg(0);
        Reg#(Sizet_20) set <- mkReg(1);

        Reg#(Bool) init_bram <- mkReg(True);
        Reg#(Bool) begin_px <- mkReg(True);


        Reg#(Bool) init <- mkReg(False  );
        Reg#(Sizet_20) row <- mkReg(0);
        Reg#(Sizet_20) col <- mkReg(0);
        Reg#(Sizet_20) hi <- mkReg(0);

        FIFOF#(Int#(2)) dummy_fifo3 <- mkSizedFIFOF(2);
        FIFOF#(Int#(2)) dummy_fifo4 <- mkSizedFIFOF(2);

        VJ_ifc dut <- mkVJpipe;

        //brams

         BRAM_Configure cfg_bm = defaultValue;
        cfg_bm.allowWriteResponseBypass = False;
        cfg_bm.memorySize = valueof(P12);
        cfg_bm.loadFormat = tagged Binary "../mem_files/alpha1_array.txt.mem";
 BRAM2Port#(Sizet_20, Pixels) br_a1 <- mkBRAM2Server(cfg_bm);
       
        cfg_bm.loadFormat = tagged Binary "../mem_files/alpha2_array.txt.mem";
 BRAM2Port#(Sizet_20, Pixels) br_a2 <- mkBRAM2Server(cfg_bm);

        cfg_bm.loadFormat = tagged Binary "../mem_files/wc_thresh_array.txt.mem";
 BRAM2Port#(Sizet_20, Pixels) br_wct <- mkBRAM2Server(cfg_bm);

        BF_ifc alpha1 <- mkBramfifoA1(br_a1, valueof(P12));
        BF_ifc alpha2 <- mkBramfifoA2(br_a2, valueof(P12));
        BF_ifc wc_thresh <- mkBramfifoWT(br_wct, valueof(P12));

	rule update_clk;
		clk <= clk + 1;
	endrule

        rule set1 (init_bram && index < hf && set == 1 );
            

            Vector#(4, Pixels) raw_odata = newVector;

            raw_odata[0] = rf_r0.sub(index);
            raw_odata[1] = rf_r1.sub(index);
            raw_odata[2] = rf_r2.sub(index);
            raw_odata[3] = rf_r3.sub(index);
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);


            set <= 2;
           
        endrule

        rule set2 (init_bram && index < hf && set == 2 );
            

            Vector #(4, Pixels) raw_odata = newVector;

            raw_odata[0] = rf_r4.sub(index);
            raw_odata[1] = rf_r5.sub(index);
            raw_odata[2] = rf_r6.sub(index);
            raw_odata[3] = rf_r7.sub(index);
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;
            dut.putbram (odata);
            set <= 3;

            alpha1.deq();
            alpha2.deq();
        endrule

        rule set3 (init_bram && index < hf && set == 3 );
            

            Vector #(4, Pixels) raw_odata = newVector;

            raw_odata[0] = rf_r8.sub(index);
            raw_odata[1] = rf_r9.sub(index);
            raw_odata[2] = rf_r10.sub(index);
            raw_odata[3] = rf_r11.sub(index);
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;
            dut.putbram (odata);
            set <= 4;
           
           alpha1.latchData;
           alpha2.latchData;
        endrule

        rule set4 (init_bram && index < hf && set == 4 );

            Vector #(4, Pixels) raw_odata = newVector;

            //raw_odata[0] = rf_a1.sub(index);
            //raw_odata[1] = rf_a2.sub(index);
            raw_odata[0] = alpha1.get;
            raw_odata[1] = alpha2.get;
            raw_odata[2] = rf_w1.sub(index);
            raw_odata[3] = rf_w2.sub(index);
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;
            dut.putbram (odata);
            set <= 5;
           
        endrule

        rule set5 (init_bram && index < hf && set == 5 );
            

            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;

            if (index < totmaps)
            begin
                x = rf_bm.sub(index);
            end
            else
            begin
                x = 0;
            end
            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;

            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 6;
           
        endrule

        rule set6 (init_bram && index < hf && set == 6 );
            

            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;
            if (index < totmaps)
            begin
                x = rf_bm.sub(index);
            end
            else
            begin
                x = 0;
            end
            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 7;
           
        endrule
    
        rule set7 (init_bram && index < hf && set == 7 );
            

            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;

            if (index < totmaps)
            begin
                x = rf_bm.sub(index);
            end
            else
            begin
                x = 0;
            end
            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 8;
           
        endrule

        rule set8 (init_bram && index < hf && set == 8 );
            

            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;

            if (index < totmaps)
            begin
                x = rf_om.sub(index);
            end
            else
            begin
                x = 0;
            end
            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 9;
           
        endrule

        rule set9 (init_bram && index < hf && set == 9 );
            

            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;
            if (index < totmaps)
            begin
                x = rf_om.sub(index);
            end
            else
            begin
                x = 0;
            end

            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 10;

            wc_thresh.deq();
           
        endrule

        rule set10 (init_bram && index < hf && set == 10 );
            
            Vector #(4, Pixels) raw_odata = newVector;
            Pixels x;

            if (index < totmaps)
            begin
                x = rf_om.sub(index);
            end
            else
            begin
                x = 0;
            end

            raw_odata[0] = x;
            raw_odata[1] = x;
            raw_odata[2] = x;
            raw_odata[3] = x;
            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            set <= 11;

            wc_thresh.latchData;
           
        endrule


        rule set11 (init_bram && index < hf && set == 11 );
            
            Vector #(4, Pixels) raw_odata = newVector;

            //raw_odata[0] = rf_wct.sub(index);
            raw_odata[0] = wc_thresh.get;
            raw_odata[1] = 0;
            raw_odata[2] = 0;
            raw_odata[3] = 0;

            PCIE_PKT odata;
            odata.data = pack (raw_odata);
            odata.valid = 1;
            odata.slot = 'h1234;
            odata.pad = 'h5;
            odata.last = 0;

            dut.putbram (odata);
            index <= index + 1;
            set <= 1;
           
        endrule

        rule done_init (init_bram && index>=hf);
            init_bram <= False;
             begin_px <= True;
            
        endrule

/*        rule img_req(!init_bram && begin_px);
                 img.deq();
            dummy_fifo3.enq(1);

        endrule

        rule img_latch(!init_bram && begin_px);
                dummy_fifo3.deq();
                img.latchData;
                dummy_fifo4.enq(1);
        endrule
*/

        rule send_px (!init_bram && begin_px);
          //  dummy_fifo4.deq();
            let bit_px = img.sub(ind);
            Vector #(4, Pixels) raw_idata = newVector;
            raw_idata[0] = 0;
            raw_idata[1] = 0;
            raw_idata[2] = 0;
            raw_idata[3] = bit_px;


              PCIE_PKT idata;
            idata.data = pack(raw_idata);
            idata.valid = 1;
            idata.slot = 'h1234;
            idata.pad = 'h5;
            idata.last = 0;

            dut.put (idata);

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
                    $finish(0);
            end

            ind <= ind + 1;
	    endrule

        rule get_px(!init_bram && begin_px);
                let out <- dut.get();
                Vector #(4, Pixels) raw_out_data = unpack(out.data);
                $display("out: %d %d", raw_out_data[2], raw_out_data[3]);
        endrule
        
        
endmodule

endpackage
