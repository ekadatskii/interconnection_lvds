`timescale 1ns / 1ps

    module full_mas_serializer(
        input clk,
        input reset,
        input [4:0] command_i,
        input [31:0] data_i,
        input [1:0] start_i,
        output [1:0] lvds_busy,
        output [1:0] serial_o
     );
          
     serializer_5bit ser_0(
         .clk(clk),
         .reset(reset),
         .data_i(command_i),
         .start_i(start_i[0]),
         .lvds_busy(lvds_busy[0]),
         .serial_o(serial_o[0])
     );
     serializer_32bit ser_1(
         .clk(clk),
         .reset(reset),
         .data_i(data_i),
         .start_i(start_i[1]),
         .lvds_busy(lvds_busy[1]),
         .serial_o(serial_o[1])
     );

    endmodule
