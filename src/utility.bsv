package utility;
import constants::*;
import Vector::*;

Sizet_20 r = fromInteger(valueof(IMGR));
Sizet_20 c = fromInteger(valueof(IMGC));
Sizet_20 sz = fromInteger(valueof(WSZ));

function Pixels abc(Pixels a);
    return a;
endfunction


function Pixels get_data0 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa);
  Pixels a;
 case (offset)

    0:a = aa[19];
    1:a = aa[29];
    2:a = aa[52];
    3:a = aa[100];
    4:a = aa[132];
    5:a = aa[161];
    6:a = aa[193];
    7:a = aa[220];
    8:a = aa[239];
    9:a = aa[253];
    10:a = aa[284];
    11:a = aa[309];
    12:a = aa[362];
    13:a = aa[385];
    14:a = aa[396];
    15:a = aa[447];
    16:a = aa[448];
    17:a = aa[449];
    18:a = aa[451];
    19:a = aa[466];
    20:a = aa[492];
    21:a = aa[531];
    22:a = aa[562];
    default: a = 0;
  endcase

  return a;
endfunction

function Pixels get_data1 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa);

  Pixels a;
     case (offset)

      0:a = aa[7];
      1:a = aa[18];
      2:a = aa[65];
      3:a = aa[72];
      4:a = aa[148];
      5:a = aa[149];
      6:a = aa[153];
      7:a = aa[164];
      8:a = aa[191];
      9:a = aa[208];
      10:a = aa[229];
      11:a = aa[240];
      12:a = aa[251];
      13:a = aa[256];
      14:a = aa[280];
      15:a = aa[384];
      16:a = aa[450];
      17:a = aa[478];
      18:a = aa[506];
      19:a = aa[517];
      20:a = aa[527];
      21:a = aa[542];
      22:a = aa[554];
      23:a = aa[573];
      24:a = aa[576];
      25:a = aa[621];
      default: a = 0;
      endcase
  return a;
endfunction

function Pixels get_data2 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;
 case (offset)

      0:a = aa[9];
      1:a = aa[20];
      2:a = aa[28];
      3:a = aa[48];
      4:a = aa[74];
      5:a = aa[97];
      6:a = aa[168];
      7:a = aa[187];
      8:a = aa[188];
      9:a = aa[213];
      10:a = aa[233];
      11:a = aa[260];
      12:a = aa[261];
      13:a = aa[277];
      14:a = aa[303];
      15:a = aa[314];
      16:a = aa[329];
      17:a = aa[356];
      18:a = aa[375];
      19:a = aa[376];
      20:a = aa[452];
      21:a = aa[499];
      22:a = aa[519];
      23:a = aa[529];
      24:a = aa[536];
      25:a = aa[551];
      26:a = aa[567];
      27:a = aa[597];
      28:a = aa[615];
      default: a = 0;
  endcase
  return a;
endfunction

function Pixels get_data3 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;
   case (offset)

      0:a = aa[41];
      1:a = aa[56];
      2:a = aa[79];
      3:a = aa[96];
      4:a = aa[109];
      5:a = aa[141];
      6:a = aa[155];
      7:a = aa[201];
      8:a = aa[249];
      9:a = aa[263];
      10:a = aa[293];
      11:a = aa[322];
      12:a = aa[383];
      13:a = aa[394];
      14:a = aa[408];
      15:a = aa[415];
      16:a = aa[428];
      17:a = aa[445];
      18:a = aa[459];
      19:a = aa[479];
      20:a = aa[532];
      21:a = aa[564];
      22:a = aa[575];
      23:a = aa[598];
      24:a = aa[611];
      default: a = 0;
    endcase
  return a;
endfunction

function Pixels get_data4 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[24];
      1:a = aa[34];
      2:a = aa[47];
      3:a = aa[58];
      4:a = aa[105];
      5:a = aa[128];
      6:a = aa[162];
      7:a = aa[179];
      8:a = aa[218];
      9:a = aa[226];
      10:a = aa[346];
      11:a = aa[364];
      12:a = aa[369];
      13:a = aa[388];
      14:a = aa[406];
      15:a = aa[425];
      16:a = aa[440];
      17:a = aa[453];
      18:a = aa[458];
      19:a = aa[486];
      20:a = aa[510];
      21:a = aa[552];
      22:a = aa[594];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data5 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[23];
      1:a = aa[53];
      2:a = aa[94];
      3:a = aa[95];
      4:a = aa[101];
      5:a = aa[139];
      6:a = aa[171];
      7:a = aa[180];
      8:a = aa[222];
      9:a = aa[267];
      10:a = aa[275];
      11:a = aa[311];
      12:a = aa[312];
      13:a = aa[333];
      14:a = aa[365];
      15:a = aa[390];
      16:a = aa[397];
      17:a = aa[409];
      18:a = aa[410];
      19:a = aa[426];
      20:a = aa[443];
      21:a = aa[463];
      22:a = aa[537];
      23:a = aa[571];
      24:a = aa[599];
      25:a = aa[608];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data6 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;
   case (offset)

      0:a = aa[15];
      1:a = aa[42];
      2:a = aa[55];
      3:a = aa[122];
      4:a = aa[138];
      5:a = aa[177];
      6:a = aa[204];
      7:a = aa[215];
      8:a = aa[228];
      9:a = aa[231];
      10:a = aa[250];
      11:a = aa[287];
      12:a = aa[307];
      13:a = aa[308];
      14:a = aa[366];
      15:a = aa[391];
      16:a = aa[411];
      17:a = aa[424];
      18:a = aa[435];
      19:a = aa[468];
      20:a = aa[497];
      21:a = aa[539];
      22:a = aa[555];
      23:a = aa[609];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data7 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[38];
      1:a = aa[82];
      2:a = aa[93];
      3:a = aa[135];
      4:a = aa[159];
      5:a = aa[195];
      6:a = aa[212];
      7:a = aa[237];
      8:a = aa[238];
      9:a = aa[258];
      10:a = aa[269];
      11:a = aa[283];
      12:a = aa[310];
      13:a = aa[328];
      14:a = aa[355];
      15:a = aa[421];
      16:a = aa[427];
      17:a = aa[465];
      18:a = aa[523];
      19:a = aa[547];
      20:a = aa[557];
      21:a = aa[570];
      22:a = aa[593];
      23:a = aa[606];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data8 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[0];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data9 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[14];
      1:a = aa[46];
      2:a = aa[119];
      3:a = aa[147];
      4:a = aa[150];
      5:a = aa[151];
      6:a = aa[163];
      7:a = aa[185];
      8:a = aa[198];
      9:a = aa[242];
      10:a = aa[262];
      11:a = aa[286];
      12:a = aa[302];
      13:a = aa[315];
      14:a = aa[340];
      15:a = aa[343];
      16:a = aa[358];
      17:a = aa[359];
      18:a = aa[429];
      19:a = aa[481];
      20:a = aa[489];
      21:a = aa[507];
      22:a = aa[520];
      23:a = aa[525];
      24:a = aa[572];
      25:a = aa[577];
      26:a = aa[591];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data10 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[6];
      1:a = aa[40];
      2:a = aa[103];
      3:a = aa[146];
      4:a = aa[173];
      5:a = aa[174];
      6:a = aa[232];
      7:a = aa[268];
      8:a = aa[279];
      9:a = aa[341];
      10:a = aa[374];
      11:a = aa[386];
      12:a = aa[405];
      13:a = aa[420];
      14:a = aa[439];
      15:a = aa[471];
      16:a = aa[488];
      17:a = aa[509];
      18:a = aa[526];
      19:a = aa[612];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data11 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[22];
      1:a = aa[45];
      2:a = aa[102];
      3:a = aa[136];
      4:a = aa[137];
      5:a = aa[156];
      6:a = aa[157];
      7:a = aa[183];
      8:a = aa[184];
      9:a = aa[210];
      10:a = aa[221];
      11:a = aa[235];
      12:a = aa[291];
      13:a = aa[324];
      14:a = aa[344];
      15:a = aa[353];
      16:a = aa[377];
      17:a = aa[398];
      18:a = aa[417];
      19:a = aa[418];
      20:a = aa[454];
      21:a = aa[511];
      22:a = aa[524];
      23:a = aa[540];
      24:a = aa[559];
      25:a = aa[584];
      26:a = aa[613];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data12 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[5];
      1:a = aa[39];
      2:a = aa[54];
      3:a = aa[61];
      4:a = aa[75];
      5:a = aa[76];
      6:a = aa[106];
      7:a = aa[140];
      8:a = aa[165];
      9:a = aa[209];
      10:a = aa[245];
      11:a = aa[246];
      12:a = aa[316];
      13:a = aa[347];
      14:a = aa[412];
      15:a = aa[413];
      16:a = aa[444];
      17:a = aa[464];
      18:a = aa[490];
      19:a = aa[530];
      20:a = aa[534];
      21:a = aa[535];
      22:a = aa[560];
      23:a = aa[586];
      24:a = aa[618];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data13 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[1];
      1:a = aa[27];
      2:a = aa[59];
      3:a = aa[87];
      4:a = aa[118];
      5:a = aa[131];
      6:a = aa[167];
      7:a = aa[175];
      8:a = aa[247];
      9:a = aa[319];
      10:a = aa[334];
      11:a = aa[335];
      12:a = aa[371];
      13:a = aa[387];
      14:a = aa[395];
      15:a = aa[414];
      16:a = aa[442];
      17:a = aa[501];
      18:a = aa[544];
      19:a = aa[548];
      20:a = aa[565];
      21:a = aa[603];
      22:a = aa[604];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data14 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[3];
      1:a = aa[10];
      2:a = aa[17];
      3:a = aa[35];
      4:a = aa[66];
      5:a = aa[99];
      6:a = aa[152];
      7:a = aa[178];
      8:a = aa[248];
      9:a = aa[259];
      10:a = aa[270];
      11:a = aa[290];
      12:a = aa[321];
      13:a = aa[336];
      14:a = aa[337];
      15:a = aa[361];
      16:a = aa[382];
      17:a = aa[393];
      18:a = aa[416];
      19:a = aa[473];
      20:a = aa[502];
      21:a = aa[545];
      22:a = aa[600];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data15 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[8];
      1:a = aa[25];
      2:a = aa[30];
      3:a = aa[57];
      4:a = aa[120];
      5:a = aa[123];
      6:a = aa[169];
      7:a = aa[192];
      8:a = aa[217];
      9:a = aa[241];
      10:a = aa[271];
      11:a = aa[274];
      12:a = aa[285];
      13:a = aa[306];
      14:a = aa[327];
      15:a = aa[368];
      16:a = aa[403];
      17:a = aa[434];
      18:a = aa[474];
      19:a = aa[476];
      20:a = aa[504];
      21:a = aa[538];
      22:a = aa[563];
      23:a = aa[568];
      24:a = aa[596];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data16 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[12];
      1:a = aa[26];
      2:a = aa[49];
      3:a = aa[68];
      4:a = aa[83];
      5:a = aa[121];
      6:a = aa[219];
      7:a = aa[234];
      8:a = aa[252];
      9:a = aa[265];
      10:a = aa[281];
      11:a = aa[282];
      12:a = aa[300];
      13:a = aa[313];
      14:a = aa[342];
      15:a = aa[378];
      16:a = aa[389];
      17:a = aa[483];
      18:a = aa[496];
      19:a = aa[516];
      20:a = aa[578];
      21:a = aa[582];
      22:a = aa[595];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data17 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[11];
      1:a = aa[67];
      2:a = aa[77];
      3:a = aa[104];
      4:a = aa[125];
      5:a = aa[160];
      6:a = aa[203];
      7:a = aa[207];
      8:a = aa[243];
      9:a = aa[244];
      10:a = aa[264];
      11:a = aa[299];
      12:a = aa[323];
      13:a = aa[367];
      14:a = aa[400];
      15:a = aa[401];
      16:a = aa[441];
      17:a = aa[456];
      18:a = aa[480];
      19:a = aa[528];
      20:a = aa[579];
      21:a = aa[589];
      22:a = aa[619];
      default: a = 0;
    endcase return a;

endfunction


function Pixels get_data18 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;
   case (offset)

      0:a = aa[21];
      1:a = aa[43];
      2:a = aa[62];
      3:a = aa[144];
      4:a = aa[145];
      5:a = aa[196];
      6:a = aa[197];
      7:a = aa[199];
      8:a = aa[292];
      9:a = aa[301];
      10:a = aa[317];
      11:a = aa[330];
      12:a = aa[331];
      13:a = aa[332];
      14:a = aa[350];
      15:a = aa[363];
      16:a = aa[381];
      17:a = aa[433];
      18:a = aa[469];
      19:a = aa[484];
      20:a = aa[522];
      21:a = aa[561];
      22:a = aa[587];
      23:a = aa[623];
      24:a = aa[624];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data19 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[16];
      1:a = aa[60];
      2:a = aa[69];
      3:a = aa[80];
      4:a = aa[112];
      5:a = aa[117];
      6:a = aa[170];
      7:a = aa[186];
      8:a = aa[206];
      9:a = aa[223];
      10:a = aa[255];
      11:a = aa[288];
      12:a = aa[289];
      13:a = aa[325];
      14:a = aa[326];
      15:a = aa[345];
      16:a = aa[357];
      17:a = aa[372];
      18:a = aa[487];
      19:a = aa[508];
      20:a = aa[521];
      21:a = aa[543];
      22:a = aa[581];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data20 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[2];
      1:a = aa[13];
      2:a = aa[44];
      3:a = aa[63];
      4:a = aa[90];
      5:a = aa[111];
      6:a = aa[126];
      7:a = aa[154];
      8:a = aa[181];
      9:a = aa[200];
      10:a = aa[230];
      11:a = aa[257];
      12:a = aa[294];
      13:a = aa[295];
      14:a = aa[296];
      15:a = aa[339];
      16:a = aa[373];
      17:a = aa[399];
      18:a = aa[422];
      19:a = aa[436];
      20:a = aa[462];
      21:a = aa[518];
      22:a = aa[533];
      23:a = aa[585];
      24:a = aa[610];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data21 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[4];
      1:a = aa[32];
      2:a = aa[73];
      3:a = aa[81];
      4:a = aa[108];
      5:a = aa[172];
      6:a = aa[190];
      7:a = aa[194];
      8:a = aa[224];
      9:a = aa[266];
      10:a = aa[318];
      11:a = aa[338];
      12:a = aa[360];
      13:a = aa[392];
      14:a = aa[437];
      15:a = aa[475];
      16:a = aa[505];
      17:a = aa[574];
      18:a = aa[601];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data22 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[71];
      1:a = aa[85];
      2:a = aa[92];
      3:a = aa[124];
      4:a = aa[133];
      5:a = aa[143];
      6:a = aa[166];
      7:a = aa[211];
      8:a = aa[225];
      9:a = aa[304];
      10:a = aa[305];
      11:a = aa[351];
      12:a = aa[352];
      13:a = aa[407];
      14:a = aa[423];
      15:a = aa[431];
      16:a = aa[472];
      17:a = aa[495];
      18:a = aa[515];
      19:a = aa[549];
      20:a = aa[553];
      21:a = aa[558];
      22:a = aa[588];
      23:a = aa[614];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data23 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[37];
      1:a = aa[50];
      2:a = aa[88];
      3:a = aa[114];
      4:a = aa[134];
      5:a = aa[189];
      6:a = aa[205];
      7:a = aa[214];
      8:a = aa[236];
      9:a = aa[273];
      10:a = aa[297];
      11:a = aa[349];
      12:a = aa[354];
      13:a = aa[432];
      14:a = aa[457];
      15:a = aa[477];
      16:a = aa[498];
      17:a = aa[512];
      18:a = aa[605];
      19:a = aa[616];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data24 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[31];
      1:a = aa[84];
      2:a = aa[113];
      3:a = aa[116];
      4:a = aa[129];
      5:a = aa[158];
      6:a = aa[182];
      7:a = aa[227];
      8:a = aa[276];
      9:a = aa[380];
      10:a = aa[404];
      11:a = aa[460];
      12:a = aa[470];
      13:a = aa[493];
      14:a = aa[494];
      15:a = aa[503];
      16:a = aa[514];
      17:a = aa[566];
      18:a = aa[580];
      19:a = aa[602];
      20:a = aa[617];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data25 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[33];
      1:a = aa[51];
      2:a = aa[64];
      3:a = aa[78];
      4:a = aa[86];
      5:a = aa[110];
      6:a = aa[130];
      7:a = aa[216];
      8:a = aa[254];
      9:a = aa[298];
      10:a = aa[320];
      11:a = aa[402];
      12:a = aa[419];
      13:a = aa[438];
      14:a = aa[446];
      15:a = aa[455];
      16:a = aa[491];
      17:a = aa[500];
      18:a = aa[590];
      19:a = aa[622];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data26 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[70];
      1:a = aa[89];
      2:a = aa[115];
      3:a = aa[127];
      4:a = aa[142];
      5:a = aa[272];
      6:a = aa[348];
      7:a = aa[370];
      8:a = aa[379];
      9:a = aa[430];
      10:a = aa[461];
      11:a = aa[485];
      12:a = aa[513];
      13:a = aa[541];
      14:a = aa[550];
      15:a = aa[583];
      16:a = aa[607];
      default: a = 0;
    endcase return a;
endfunction

function Pixels get_data27 ( BitSz_6 offset, Vector#(TMul#(WSZ,WSZ), Pixels) aa );

  Pixels a;

   case (offset)

      0:a = aa[36];
      1:a = aa[91];
      2:a = aa[98];
      3:a = aa[107];
      4:a = aa[176];
      5:a = aa[202];
      6:a = aa[278];
      7:a = aa[467];
      8:a = aa[482];
      9:a = aa[546];
      10:a = aa[556];
      11:a = aa[569];
      12:a = aa[592];
      13:a = aa[620];
      default: a = 0;
    endcase return a;
endfunction


endpackage
