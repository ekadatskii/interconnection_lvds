
`timescale 1 ns / 1 ps

	module serdes_lvds_v1_0 
	(
	   // serialized output data
	   output [22:0] serial_o,
	   // busy flag, serializer send something
       output [22:0] lvds_busy,
       // st_flag output infors controller that it is
       // begin || end of the frame
       output [22:0] st_flag_o,
       output [183:0] data_o,
	   input clk, 
	   // Begin to encode && send serialized data
	   input [22:0] start_i,
	   // serialized input data
	   input [22:0] serial_i,
	   // st_flag input means not to encode data for this pin
       // It used when we send start/stop byte(0x7E)
	   input [22:0] st_flag_i,
	   input [183:0] data_i 
	);
    
    // Massive of serializer modules
    full_mas_serializer ms(
        .clk(clk),
        .reset(reset),
        .data_i(data_i),
        .st_flag(st_flag_i),
        .start_i(start_i),
        .lvds_busy(lvds_busy),
        .serial_o(serial_o)
    );
    
    // Massive of deserializer modules
    full_mas_deserializer md(
        .clk(clk),
        .reset(reset),
        .serial_i(serial_i),
        .st_flag(st_flag_o),
        .data_o(data_o)
    );

	endmodule
