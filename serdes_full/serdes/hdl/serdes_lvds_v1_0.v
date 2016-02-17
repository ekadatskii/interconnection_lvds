
`timescale 1 ns / 1 ps

	module serdes_lvds_v1_0 
	(
	   input clk, 
	   input [1:0] start_i,
	   input [4:0] command_i,
	   input [31:0] data_i,
	   input [1:0] serial_i,
	   output [1:0] serial_o,
	   output [1:0] lvds_busy,
	   output [36:0] data_o
	);
    
    
    full_mas_serializer ms(
        .clk(clk),
        .reset(reset),
        .command_i(command_i),
        .data_i(data_i),
        .start_i(start_i),
        .lvds_busy(lvds_busy),
        .serial_o(serial_o)
    );
    
    full_mas_deserializer md(
        .clk(clk),
        .reset(reset),
        .serial_i(serial_i),
        //.axi_lite_ready_o(),
        .data_o(data_o)
    );

	endmodule
