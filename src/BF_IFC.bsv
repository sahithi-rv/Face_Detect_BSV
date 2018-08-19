package BF_IFC;

import constants::*;

//INTERFACE FOR BRAM FIFOs FOR ALPHAS, WEIGHTS, THRESHOLD
interface BF_ifc;
	method Action enq(Pixels data);
	method Action latchData;
	method Action deq;
    method Pixels get;
    method Action reset;
endinterface

endpackage
