package IFC; 

// Multiplier IFC

import constants::*;

/*interface VJ_ifc;
    method Action  read_inp (Pixels px);
    method ActionValue#(BitSz_20) result();
    method Bit#(2) isDone;
    
endinterface
*/

//INTERFACE FOR vj pipe
interface VJ_ifc;
    method Action  put (PCIE_PKT px);
    method Action  putbram (PCIE_PKT px);
    method ActionValue#(PCIE_PKT) get();
    
endinterface
        
endpackage
