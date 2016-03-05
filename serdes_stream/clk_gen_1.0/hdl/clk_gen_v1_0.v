`timescale 1ns / 1ps

//Number generator to test FIFO with serializer
//or deserializer
module num_gen(
    input clk,
    output clk_ms,
    output clk_serdes,
//    output reg [7:0] data,
//    output reg wr_en,
//    output reg rd_en,
    output xg,
    output reg res,
    output reg res_n
    
//    output reg res_n2=0,
//    output wire [28:0] clks_o
);  

   // for different clock generation 
   // in future
    assign clk_ms = clk;
    assign clk_serdes = clk;    
    reg [10:0] i = 0;

   // Reset flag generation
   // positive and negative    
    always @(posedge clk)
    begin
        if (i <= 3) begin
            res_n <= 0;
            res <= 1;
        end
        else begin
            res_n <= 1;
            res <= 0;
        end
        i <= i + 1;                    
    end
//(* mark_debug = "true" *)reg [30:0] chkr=0;
//(* mark_debug = "true" *)reg clk_0 = 0;
//(* mark_debug = "true" *)reg clk_1 = 0;
//(* mark_debug = "true" *)reg clk_2 = 0;
//(* mark_debug = "true" *)reg clk_3 = 0;
//(* mark_debug = "true" *)reg clk_4 = 0;
//(* mark_debug = "true" *)reg clk_5 = 0;
//(* mark_debug = "true" *)reg clk_6 = 0;
//(* mark_debug = "true" *)reg clk_7 = 0;
//(* mark_debug = "true" *)reg clk_8 = 0;
//(* mark_debug = "true" *)reg clk_9 = 0;
//(* mark_debug = "true" *)reg clk_10 = 0;
//(* mark_debug = "true" *)reg clk_11 = 0;
//(* mark_debug = "true" *)reg clk_12 = 0;
//(* mark_debug = "true" *)reg clk_13 = 0;
//(* mark_debug = "true" *)reg clk_14 = 0;
//(* mark_debug = "true" *)reg clk_15 = 0;
//(* mark_debug = "true" *)reg clk_16 = 0;
//(* mark_debug = "true" *)reg clk_17 = 0;
//(* mark_debug = "true" *)reg clk_18 = 0;
//(* mark_debug = "true" *)reg clk_19 = 0;
//(* mark_debug = "true" *)reg clk_20 = 0;
//(* mark_debug = "true" *)reg clk_21 = 0;
//(* mark_debug = "true" *)reg clk_22 = 0;
//(* mark_debug = "true" *)reg clk_23 = 0;
//(* mark_debug = "true" *)reg clk_24 = 0;
//(* mark_debug = "true" *)reg clk_25 = 0;
//(* mark_debug = "true" *)reg clk_26 = 0;
//(* mark_debug = "true" *)reg clk_27 = 0;
//(* mark_debug = "true" *)reg clk_28 = 0;

//assign clks_o[0] = clk_0;
//assign clks_o[1] = clk_1;
//assign clks_o[2] = clk_2;
//assign clks_o[3] = clk_3;
//assign clks_o[4] = clk_4;
//assign clks_o[5] = clk_5;
//assign clks_o[6] = clk_6;
//assign clks_o[7] = clk_7;
//assign clks_o[8] = clk_8;
//assign clks_o[9] = clk_9;
//assign clks_o[10] = clk_10;
//assign clks_o[11] = clk_11;
//assign clks_o[12] = clk_12;
//assign clks_o[13] = clk_13;
//assign clks_o[14] = clk_14;
//assign clks_o[15] = clk_15;
//assign clks_o[16] = clk_16;
//assign clks_o[17] = clk_17;
//assign clks_o[18] = clk_18;
//assign clks_o[19] = clk_19;
//assign clks_o[20] = clk_20;
//assign clks_o[21] = clk_21;
//assign clks_o[22] = clk_22;
//assign clks_o[23] = clk_23;
//assign clks_o[24] = clk_24;
//assign clks_o[25] = clk_25;
//assign clks_o[26] = clk_26;
//assign clks_o[27] = clk_27;
//assign clks_o[28] = clk_28;

//always @(posedge clk) 
//begin
//    if ((chkr % 2) == 0) clk_0 <= ~clk_0;
//    if ((chkr % 3) == 0) clk_1 <= ~clk_1;
//    if ((chkr % 4) == 0) clk_2 <= ~clk_2;
//    if ((chkr % 5) == 0) clk_3 <= ~clk_3;
//    if ((chkr % 6) == 0) clk_4 <= ~clk_4;
//    if ((chkr % 7) == 0) clk_5 <= ~clk_5;
//    if ((chkr % 8) == 0) clk_6 <= ~clk_6;
//    if ((chkr % 9) == 0) clk_7 <= ~clk_7;
//    if ((chkr % 10) == 0) clk_8 <= ~clk_8;
//    if ((chkr % 11) == 0) clk_9 <= ~clk_9;
//    if ((chkr % 12) == 0) clk_10 <= ~clk_10;
//    if ((chkr % 13) == 0) clk_11 <= ~clk_11;
//    if ((chkr % 14) == 0) clk_12 <= ~clk_12;
//    if ((chkr % 15) == 0) clk_13 <= ~clk_13;
//    if ((chkr % 16) == 0) clk_14 <= ~clk_14;
//    if ((chkr % 17) == 0) clk_15 <= ~clk_15;
//    if ((chkr % 18) == 0) clk_16 <= ~clk_16;
//    if ((chkr % 19) == 0) clk_17 <= ~clk_17;
//    if ((chkr % 20) == 0) clk_18 <= ~clk_18;
//    if ((chkr % 21) == 0) clk_19 <= ~clk_19;
//    if ((chkr % 22) == 0) clk_20 <= ~clk_20;
//    if ((chkr % 23) == 0) clk_21 <= ~clk_21;
//    if ((chkr % 24) == 0) clk_22 <= ~clk_22;
//    if ((chkr % 25) == 0) clk_23 <= ~clk_23;
//    if ((chkr % 26) == 0) clk_24 <= ~clk_24;
//    if ((chkr % 27) == 0) clk_25 <= ~clk_25;
//    if ((chkr % 28) == 0) clk_26 <= ~clk_26;
//    if ((chkr % 29) == 0) clk_27 <= ~clk_27;
//    if ((chkr % 30) == 0) clk_28 <= ~clk_28;
//    //if (chkr == 12) chkr <= 0;
//    //else 
//    chkr <= chkr + 1;
//end   
    
endmodule
