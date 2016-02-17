`timescale 1ns / 1ps

    module full_mas_deserializer (
        input clk,
        input reset,
        input [1:0] serial_i,
        //output axi_lite_ready_o,
        output [36:0] data_o
     );
     
     // locals
//     assign axi_lite_ready_o = (strb == 8'b11111111) ? 1'b1: 
//                                                   1'b0;                                  
     
     deserializer_5bit deser_0 (
         .clk(clk),
         .reset(reset),
         .serial_i(serial_i[0]),
         .data_o(data_o[4:0])
     );
     
     deserializer_32bit deser_1 (
         .clk(clk),
         .reset(reset),
         .serial_i(serial_i[1]),
         .data_o(data_o[36:5])
     );
        
endmodule
