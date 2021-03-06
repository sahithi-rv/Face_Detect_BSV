package BF_IFC_20;

import constants::*;

////INTERFACE FOR BRAM FIFOs FOR RECTS

interface BF_ifc20;
        method Action enq(BitSz_11 data);
	method Action latchData;
	method Action deq;

    method BitSz_11 get;
        method Action reset();
endinterface

endpackage
