package sqrt;

import constants::*;

(*synthesize*)
module mkSqrt( Empty);

Reg#(UData_32) clk <- mkReg(0);
Reg#(Sizet_20) curr_state <- mkReg(11);
Reg#(UData_32) interm1 <- mkReg(0);
Reg#(UData_32) interm2 <- mkReg(0);
Reg#(UData_32) interm3 <- mkReg(0);
Reg#(UData_32) dum1 <- mkReg(0);
Reg#(UData_32) dum2 <- mkReg(0);
Reg#(UData_32) dum3 <- mkReg(0);
Reg#(UData_32) dum4 <- mkReg(0);
Reg#(UData_32) stddev <- mkReg(5588864);
Reg#(Data_32) stddev0 <- mkReg(0);

rule clock;
clk <= clk + 1;
endrule

for (Sizet_20 i = 0;i<15;i = i +1)
begin

    rule sq1 (curr_state == (11+i));
        interm3 <= interm3 << 2;
        dum1 <= (stddev >> 30);
        curr_state <= 101 + i;
    endrule


    rule sq2 ( curr_state == 101+i);
        interm3 <= interm3 + dum1;
        stddev <= (stddev<<2);
        interm1 <= (interm1 <<1);
        curr_state <= 151 + i;
    endrule

    rule sq3 (curr_state == 151 + i);
        interm2 <= (interm1 <<1) | 1;
        curr_state <= 201 + i;
    endrule

    rule sq4 (curr_state == 201 + i);
        if ( interm3 >= interm2 )
        begin
          interm3 <= (interm3-interm2);
          interm1 <= interm1 + 1;
        end
        curr_state <= (251+i);
    endrule

    rule sq5 (curr_state == 251 + i);
        $display("interm1: ", interm1);
        curr_state <= (11+i+1);
    endrule
end

    rule sq1_15 (curr_state == (26));
        interm3 <= interm3 << 2;
        dum1 <= (stddev >> 30);
        curr_state <= 116;
    endrule


    rule sq2_15 ( curr_state == 116);
        interm3 <= interm3 + dum1;
        stddev <= (stddev<<2);
        interm1 <= (interm1 <<1);
        curr_state <= 166;
    endrule

    rule sq3_15 (curr_state == 166);
        interm2 <= (interm1<<1) | 1;
        curr_state <= 216;
    endrule

    rule sq4_15 (curr_state == 216);
        if ( interm3 >= interm2 )
        begin
          interm3 <= (interm3-interm2);
          interm1 <= interm1 + 1;
        end
        curr_state <= 2000;
    endrule

    rule one (curr_state == 2000);
        stddev0 <= unpack(pack(interm1));
        $display("stddev: %d",interm1);
        curr_state <= 2001;
    endrule

    rule ending (curr_state == 2001);
    $display("stddev0: %d\n",stddev0);
        $finish(0);
    endrule

endmodule

endpackage
/*

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
*/
