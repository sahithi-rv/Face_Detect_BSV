package bank_IFC;

import constants::*;

//INTERFACE FOR BRAM FIFOS  OF BANK AND OFFSET MAP
interface FIFORand2;
        method Action enq(BitSz_6 data);
        method Action latchData;
        method Action deq(Sizet_11 addr);
        method BitSz_6 get;
endinterface: FIFORand2

endpackage
