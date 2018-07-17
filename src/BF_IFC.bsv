package BF_IFC;

import constants::*;

interface BF_ifc;

	method Action enq(Pixels data);
	method Action latchData;
	method Action deq;
    method Pixels get;
    method Action reset;
endinterface

endpackage
