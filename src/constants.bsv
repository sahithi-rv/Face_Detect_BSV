package constants;

typedef 240 IMGR;
typedef 185 IMGC;
typedef 25 WSZ;
typedef 2913 HF;

typedef TMul#(HF,11) INIT_TIME;
typedef 25 STAGES;
typedef 4 WT;
typedef 28 N_BANKS;
typedef 12 N_COORDS;

/*typedef 50 IMGR;
typedef 50 IMGC;
typedef 5 WSZ;
typedef 4 WT;
typedef TMul#(TAdd#(TMul#(TSub#(WSZ,1),IMGC),WSZ),3) INIT_TIME;
typedef 2913 HF;
typedef 25 STAGES;*/

typedef Int#(20) Sizet_20;
typedef Bit#(20) BitSz_20;
typedef Int#(11) Sizet_11;
typedef Bit#(11) BitSz_11;
typedef Int#(6) Sizet_6;
typedef Bit#(6) BitSz_6;
typedef Int#(16) Sizet;
typedef Bit#(32) Pixels;
typedef Int#(32) Data_32;
typedef UInt#(32) UData_32;
typedef Bit#(16) BitSz;
typedef Bit#(6) BitSz6;
typedef Int#(6) Sizet6;

typedef 262144 P18;
typedef 65536 P16;
typedef 1024 P10;
typedef 4096 P12;
typedef 2048 P11;
typedef 512 P9;
typedef 256 P8;
typedef 32 P5;
typedef 8192 P13;

typedef struct {
   Bit #(1) valid;
   Bit #(128) data;
   Bit #(16) slot;
   Bit #(4) pad;
   Bit #(1) last;
} PCIE_PKT deriving (Bits, Eq, FShow);



typedef struct{
   Sizet_20 x  ;
   Sizet_20 y;
} Outputs deriving(Bits, Eq);

typedef struct{
    BitSz_11 r0;
    BitSz_11 r1;
    BitSz_11 r2;
    BitSz_11 r3;
    BitSz_11 r4;
    BitSz_11 r5;
    BitSz_11 r6;
    BitSz_11 r7;
    BitSz_11 r8;
    BitSz_11 r9;
    BitSz_11 r10;
    BitSz_11 r11;

    Pixels a1;
    Pixels a2;

    Pixels w2;
    Pixels w3;

    Pixels wct;

} Input deriving(Eq, Bits);

typedef struct{
  Sizet_20 row;
  Sizet_20 col;
  Pixels px;

} PipeLine deriving(Eq, Bits);

typedef struct{
Sizet_11 x1;
Sizet_11 y1;
Sizet_11 w1;
Sizet_11 h1;

Sizet_11 x2;
Sizet_11 y2;
Sizet_11 w2;
Sizet_11 h2;

Sizet_11 x3;
Sizet_11 y3;
Sizet_11 w3;
Sizet_11 h3;


} Coords deriving(Eq, Bits);

typedef struct{
BitSz_6 b0;
BitSz_6 b1;
BitSz_6 b2;
BitSz_6 b3;

BitSz_6 b4;
BitSz_6 b5;
BitSz_6 b6;
BitSz_6 b7;

BitSz_6 b8;
BitSz_6 b9;
BitSz_6 b10;
BitSz_6 b11;


} Banks deriving(Eq, Bits);


typedef struct {
	Data_32 rect1;
	Data_32 rect2;
	Data_32 rect3;

Data_32 weights2;
Data_32 weights3;

	Data_32 wc_thresh;
  Data_32 alpha2;
  Data_32 alpha1;

}Rects deriving(Eq, Bits);

endpackage
