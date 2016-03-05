
`timescale 1 ns / 1 ps
//`include "crc_7.v" 

	module stream_controller_v1_0 #
	(
	    // Number of available lvds pins
	    parameter LVDS_PIN_NUMBER = 23,
	    // Need to control first initialization of Controllers and SERDES
	    // one Controller will send signals to another Controller and
	    // wait for responde. 
	    // 1 - for master
        // 0 - for slave
	    parameter MASTER_SLAVE = 1,
	    parameter DATA_WIDTH = 32
	)
	(
    // common ports	    
        input clk,
        input reset, //not used yet
        
    // ports for working with FIFO
        // command to FIFO used for resend functionality
        output reg [3:0] fifo_command_o,
        output fifo_rden_o,	    
	    output reg fifo_wren_o,    	    
		output reg [DATA_WIDTH-1 : 0] fifo_data_o,
		input [DATA_WIDTH-1 : 0] fifo_data_i,
		// used for initiate, who responds for 
		// fifo full/empty		
		input fifo_full_axi_i,
		input fifo_empty_axi_i,
		input fifo_full_ctrl_i,
		input fifo_empty_ctrl_i, 
		
    // Ports for serdes communication 
		output reg [LVDS_PIN_NUMBER * 8 - 1 : 0] data_reg,
		output [LVDS_PIN_NUMBER - 1 : 0] start_o,
		// Indicate where start/end(0x7E) contains to send it without encode
        output reg [LVDS_PIN_NUMBER - 1 : 0] st_flag_o,
        // Indicate start/end frame when data receive
        input [LVDS_PIN_NUMBER - 1 : 0] st_flag_i,      
		input [LVDS_PIN_NUMBER * 8 - 1 : 0] data_i,
		input [LVDS_PIN_NUMBER - 1 : 0] lvds_busy
		 
	);
	// We collect data, until number of lvds pins can send it together (8 bit on one lvds pin)
	// or until fifo will be empty
	
	// Controller for end of receiving data from another SERDES
	reg receive_end;
	// Register to receive CRC data
	reg [7:0] crc_reg;
    // Data, which was received from FIFO but didn't hit to the frame part
    reg [23:0] data_rest;
    // Pointer to jump for 8 bit data_fifo_o parts. Used for collecting 32 bits words
    reg [2:0] data_fifo_ptr;
    // Flag indicates, what part of Data didn't hit to the frame part
    reg [2:0] rest_num;
    // TO DO: change data_poiner size with clogb function
    // Pointer to lvds pins data
    reg [5:0] data_pointer;
    // Indicate add of frame start(0x7E)
    reg start_flg;
    // Indicate add of frame end(0x7E)
    reg end_flg;
    // Indicate, that end of frame ready to sent
    reg finish_flg;
    // TODO: try to use data_reg without data_inp
    reg [LVDS_PIN_NUMBER * 8 - 1 : 0] data_inp;
    // Checker to control next data receive
    reg [3:0] receive_checker;
    // parameter to control when new data received
    localparam NEW_DATA = 10;
    // st_flag to contain st_flag_i when data receives from serdes
    reg [LVDS_PIN_NUMBER - 1 : 0] st_flag;
    // crc for sending data
    reg [7:0] crc_7;
    // indicate that crc was added to the frame
    reg crc_flag;
    
    // Specials for HANDSHAKE state
    // Indicate, that Request-Response have done and each part ready to work
    // Indicate end of handshake
    reg init_ready=0;
    // Indicate that all lvds pins charged by 0x7E
    reg load_hdshk;
    // used to rerun send of 0x7E on all pins if time of response is over
    reg start_disable;
    // cheker for time response. if 5'b11111 then resend 0x7E
    reg [4:0] hdshk_checker;
                       
       	
	reg [9:0] state          = 10'b0000000001;
	localparam INIT          = 10'b0000000001;
	localparam WAIT          = 10'b0000000010;
	localparam SEND          = 10'b0000000100;
	localparam RECEIVE       = 10'b0000001000;
	localparam HANDSHAKE     = 10'b0000010000;
	localparam WAIT_RESPONSE = 10'b0000100000;
	localparam SEND_RESPONSE = 10'b0001000000;
    	
	
	always @(posedge clk)
	begin: STM
	   case(state)
	       // set to zero most registers. next state transition
	       // is HANDSHAKE. If HANDSHAKE is READY goes to WAIT state
	       INIT: begin
	           if (!init_ready && lvds_busy == 0)
	               state <= HANDSHAKE;
               else if (init_ready)	               
	               state <= WAIT;
	       end
	       // initial handshake of 2 boards
	       HANDSHAKE: begin
                if (init_ready) state <= INIT;     	           
	       end
	       // waiting until all send buffer will be filled or FIFO empty taken(Transmitter)
	       // waiting intil begin of the frame will be taken(Receiver)
	       WAIT: begin
	            // Transmitter part
	            if (!lvds_busy[0] && data_pointer == LVDS_PIN_NUMBER)
	               state <= SEND; 
                else if (!lvds_busy[0] && finish_flg)
                   state <= SEND;
                // Receiver part
                else if (st_flag_i[0] == 1)
                   state <= RECEIVE;                   	                                                                       	       	           
	       end
	       // send data + start flags to SERDES
	       // next transition is WAIT if frame not ended
	       // or WAIT_RESPONSE if frame ended
	       SEND: begin
	           if (finish_flg)
	               state <= WAIT_RESPONSE; 
	           else       
	               state <= WAIT;
	       end
           // waiting for response and send command to receive
           // next data if crc right or resend if crc wrong 
           // now working just if lvds_pin_number >= 2
	       WAIT_RESPONSE: begin
	           if (st_flag_i[0] && LVDS_PIN_NUMBER >= 2)
	               state <= INIT;
	       end	       
	       // receive data and send it to FIFO until end of the frame
	       RECEIVE: begin
	             if (receive_end)
	               state <= SEND_RESPONSE;
	       end
	       // send response with checked crc. 2 bytes: 0x7e crc_response
	       SEND_RESPONSE: begin
               state <= INIT;
           end
	   endcase	   
	end	

	always @(posedge clk)
	begin: EX
	   case(state)
	       INIT: begin
	            data_rest <= 0;
	            rest_num <= 0;
                data_reg <= 0;   
                data_pointer <= 0; 
                start_flg <= 0; 
                end_flg <= 0; 
                finish_flg <= 0; 
                st_flag_o <= 0;
                data_inp <= 0;
                receive_checker <= 0;
                load_hdshk <= 0;
                start_disable <= 0;
                hdshk_checker <= 0;
                crc_7 <= 0; 
                crc_flag <= 0; 
                st_flag <= 0; 
                fifo_wren_o <= 0;
                fifo_data_o <= 0;
                data_fifo_ptr <= 0;
                crc_7 <= 0;
                receive_end <= 0;
                crc_reg <= 0;
                fifo_command_o <= 0;
	       end
	       HANDSHAKE: begin
	       // ------------------------------------------------
	            if (MASTER_SLAVE) begin
                    if (!load_hdshk) begin
                        data_reg <= {LVDS_PIN_NUMBER{8'h7E}};
                        st_flag_o <= {LVDS_PIN_NUMBER{1'b1}};
                        load_hdshk <= 1'b1;       
                    end
                    else if (load_hdshk) 
                        start_disable <= 1'b1;
                        
                    if (start_disable && hdshk_checker == {5{1'b1}}) 
                    begin
                        start_disable <= 1'b0;
                        hdshk_checker <= 0;
                    end                    
                    else if (start_disable) 
                        hdshk_checker <= hdshk_checker + 1; 
                        
                    if (st_flag_i == {LVDS_PIN_NUMBER{1'b1}}) 
                        init_ready <= 1'b1;                                          
                end
            // ------------------------------------------------                	
                else if (!MASTER_SLAVE) begin
                    if (!load_hdshk) begin
                        data_reg <= {LVDS_PIN_NUMBER{8'h7E}};
                        st_flag_o <= {LVDS_PIN_NUMBER{1'b1}};
                        load_hdshk <= 1'b1;       
                    end
                    if (st_flag_i == {LVDS_PIN_NUMBER{1'b1}})  
                        init_ready <= 1'b1;
                end  
            // ------------------------------------------------                             
	       end
	       WAIT: begin
	       // ------------------------------------------------------------------------------------
	            // add 0x7E - start frame to output register
	            if (!start_flg && !fifo_empty_ctrl_i && data_pointer != LVDS_PIN_NUMBER) begin
	               data_reg[data_pointer * 8 + 7 -: 8] <= 8'h7E;
	               data_pointer <= data_pointer + 1;
	               st_flag_o[0] <= 1'b1;
	               start_flg <= 1'b1;
	            end
	       // ------------------------------------------------------------------------------------
	            // push the rest bytes of 4bytes word to output buffer if rest == 3 bytes
	            else if (rest_num[2] && data_pointer != LVDS_PIN_NUMBER) begin
	                data_reg[data_pointer * 8 + 7 -: 8] <= data_rest[7:0];
	                if (LVDS_PIN_NUMBER - data_pointer > 2) begin
                        data_reg[data_pointer * 8 + 15 -: 8] <= data_rest[15:8];
                        data_reg[data_pointer * 8 + 23 -: 8] <= data_rest[23:16];
                        data_rest <= 0;
                        rest_num  <= 0;
                    end               
                    else if (LVDS_PIN_NUMBER - data_pointer > 1) begin
                        data_reg[data_pointer * 8 + 15 -: 8] <= data_rest[15:8]; 
                        data_rest[7:0] <= data_rest[23:16];
                        data_rest[23:8] <= 0;                   
                        rest_num <= 3'b001;
                    end 
                    else begin
                        data_rest[7:0]  <= data_rest[15:8];                    
                        data_rest[15:8] <= data_rest[23:16];
                        data_rest[23:16] <= 0;                   
                        rest_num <= 3'b011;                    
                    end                                                                    	          
                                        
                    if (LVDS_PIN_NUMBER - data_pointer >= 3)    
                        data_pointer <= data_pointer + 3;
                    else
                        data_pointer <= LVDS_PIN_NUMBER;                                                                                                                	                    
	            end	            
            // ------------------------------------------------------------------------------------
	            // push the rest bytes of 4bytes word to output buffer if rest == 2 bytes                            
	            else if (rest_num[1] && data_pointer != LVDS_PIN_NUMBER) begin
                    data_reg[data_pointer * 8 + 7 -: 8] <= data_rest[7:0];        
                    if (LVDS_PIN_NUMBER - data_pointer > 1) begin
                        data_reg[data_pointer * 8 + 15 -: 8] <= data_rest[15:8]; 
                        data_rest <= 0;                    
                        rest_num <= 0;
                    end 
                    else begin
                        data_rest[7:0]  <= data_rest[15:8]; 
                        data_rest[15:8] <= 0;                   
                        rest_num <= 3'b001;                    
                    end                                                                                  
                                        
                    if (LVDS_PIN_NUMBER - data_pointer >= 2)    
                        data_pointer <= data_pointer + 2;
                    else
                        data_pointer <= LVDS_PIN_NUMBER;                                                                                                                                        
                end
            // ------------------------------------------------------------------------------------
                // push the rest bytes of 4bytes word to output buffer if rest == 3 bytes
	            else if (rest_num[0] && data_pointer != LVDS_PIN_NUMBER) begin
                    data_reg[data_pointer * 8 + 7 -: 8] <= data_rest[7:0]; 
                    data_rest <= 0;       
                    rest_num <= 0;                                                                               
                    data_pointer <= data_pointer + 1;
                end                               	            
            // ------------------------------------------------------------------------------------
	            // contains Data until fifo not empty or all pins will be used for sending
                else if (!fifo_empty_ctrl_i && fifo_rden_o && data_pointer != LVDS_PIN_NUMBER) begin
                    // push always minimun 1 byte to buffer
                    data_reg[data_pointer * 8 + 7 -: 8] <= fifo_data_i[7:0];
                    // push 3 another bytes to buffer
                    if (LVDS_PIN_NUMBER - data_pointer > 3) begin
                        data_reg[data_pointer * 8 + 15 -: 8] <= fifo_data_i[15:8];
                        data_reg[data_pointer * 8 + 23 -: 8] <= fifo_data_i[23:16];
                        data_reg[data_pointer * 8 + 31 -: 8] <= fifo_data_i[31:24];
                    end 
                    // push 2 another bytes to buffer
                    else if (LVDS_PIN_NUMBER - data_pointer > 2) begin
                        data_reg[data_pointer * 8 + 15 -: 8] <= fifo_data_i[15:8];
                        data_reg[data_pointer * 8 + 23 -: 8] <= fifo_data_i[23:16];
                    end                       
                    // push 1 another byte to buffer
                    else if (LVDS_PIN_NUMBER - data_pointer > 1) 
                        data_reg[data_pointer * 8 + 15 -: 8] <= fifo_data_i[15:8];
                    
                    // push 3 rest bytes to reserv(next send)      
                    if (LVDS_PIN_NUMBER - data_pointer < 2) begin
                        data_rest[7:0] <=  fifo_data_i[15:8];  
                        data_rest[15:8] <=  fifo_data_i[23:16];
                        data_rest[23:16] <=  fifo_data_i[31:24];
                        rest_num <= 3'b111;
                    end
                    // push 2 rest bytes to reserv(next send)                         
                    else if (LVDS_PIN_NUMBER - data_pointer < 3) begin
                        data_rest[7:0] <=  fifo_data_i[23:16];
                        data_rest[15:8] <=  fifo_data_i[31:24];
                        rest_num <= 3'b011;                         
                    end
                    // push 1 rest byte to reserv(next send)
                    else if (LVDS_PIN_NUMBER - data_pointer < 4) begin
                        data_rest[7:0] <=  fifo_data_i[31:24];
                        rest_num <= 3'b001;                         
                    end                                                                                                                       
                    // count a pointer of used lvds pins                            
                    if (LVDS_PIN_NUMBER - data_pointer >= 4)    
                        data_pointer <= data_pointer + 4;
                    else
                        data_pointer <= LVDS_PIN_NUMBER;    

                    crc_7 = nextCRC7_D32(fifo_data_i,crc_7);                                             
                end
            // ------------------------------------------------------------------------------------
                // if the end of the frame, then push crc to the frame                
                else if (end_flg && !crc_flag && data_pointer != LVDS_PIN_NUMBER) begin
                    data_reg[data_pointer * 8 + 7 -: 8] <= crc_7;
                    data_pointer <= data_pointer + 1;
                    crc_flag <= 1'b1;
                end
            // ------------------------------------------------------------------------------------
                // if the end of the frame, then push 0x7E(end) after crc                
                else if (end_flg && crc_flag && !finish_flg && data_pointer != LVDS_PIN_NUMBER) begin   
                    data_reg[data_pointer * 8 + 7 -: 8] <= 8'h7E;
	                st_flag_o[data_pointer] <= 1'b1;
                    finish_flg <= 1'b1;                    
                end                    
            // ------------------------------------------------------------------------------------
                // end of the frame                
                if (start_flg && fifo_empty_ctrl_i) end_flg <= 1'b1;
            // ------------------------------------------------------------------------------------                
                // receiver first data collection
                if (st_flag_i[0]) begin 
                    data_inp <= data_i;
                    st_flag <= st_flag_i;
                    st_flag[LVDS_PIN_NUMBER - 1 : 1] <= st_flag_i[LVDS_PIN_NUMBER - 1 : 1];
                    st_flag[0] <= 0;
                    data_pointer <= data_pointer + 1;                    
                end         
            // ------------------------------------------------------------------------------------                                                                                                                                                   	       
	       end
	       // send data to serdes. Works with assigns below 
	       SEND: begin
                data_pointer <= 0;
                data_reg <= 0;
                st_flag_o <= 0;
                if (finish_flg) begin
                    finish_flg <= 0;
                    end_flg <= 0;
                    start_flg <= 0;
                end                                                                                            	          	                        
	       end
	       // send response to serdes. Works with assigns below
	       SEND_RESPONSE: begin
	            fifo_command_o <= 4'b0001;
                receive_end <= 0;	                	           
	       end
	       // waiting until {0x7E ; crc_check} frame comes
	       // works with number of lvds pins >= 2 
	       WAIT_RESPONSE: begin
	           // TODO: add response for only 1 pin
	           if (st_flag_i[0] && data_i[15:8] == 1 && LVDS_PIN_NUMBER >= 2)
	               fifo_command_o <= 4'b0001; 
               else if (st_flag_i[0] && data_i[15:8] != 1 && LVDS_PIN_NUMBER >= 2)
                   fifo_command_o <= 4'b0010;	                                  
           end
           // receive new data 
	       RECEIVE: begin
	            // Count crc from received data	 
                if (fifo_wren_o) crc_7 = nextCRC7_D32(fifo_data_o,crc_7);
	            receive_checker <= receive_checker + 1;
                
                // receive next data with counter using
	            if (receive_checker == NEW_DATA && !receive_end) begin
	               receive_checker <= 0;
	               data_inp <= data_i;
	               st_flag <= st_flag_i;
	               data_pointer <= 0;
                   fifo_wren_o <= 1'b0;               
                end	        
                // cointains data to 32 bits word and send it to FIFO                                                                                                                                                   	                              
                else 
                   
                   if (data_pointer != LVDS_PIN_NUMBER && !receive_end) begin
                       // ------------------------------------------------------------------------------------
                       // send all 4 bytes to fifo                                      
                       if (LVDS_PIN_NUMBER - data_pointer >= 4 && data_fifo_ptr < 1) begin
                           if (st_flag[data_pointer + 1]) begin
                               crc_reg <= data_inp[data_pointer * 8 + 7 -: 8];
                               receive_end <= 1'b1;
                           end                               
                           else begin                                 
                               fifo_data_o[data_fifo_ptr * 8 + 7 -: 8] <= data_inp[data_pointer * 8 + 7 -: 8];  
                               fifo_data_o[data_fifo_ptr * 8 + 15 -: 8] <= data_inp[(data_pointer + 1) * 8 + 7 -: 8];   
                               fifo_data_o[data_fifo_ptr * 8 + 23 -: 8] <= data_inp[(data_pointer + 2) * 8 + 7 -: 8];   
                               fifo_data_o[data_fifo_ptr * 8 + 31 -: 8] <= data_inp[(data_pointer + 3) * 8 + 7 -: 8];
                               data_fifo_ptr <= 0;
                               fifo_wren_o <= 1'b1;
                               data_pointer <= data_pointer + 4;
                           end
                       end                    
                       // ------------------------------------------------------------------------------------
                       // add 3 bytes and send 4 bytes to FIFO if all 4 bytes collected                              
                       else if (LVDS_PIN_NUMBER - data_pointer >= 3 && data_fifo_ptr < 2) begin
                           if (data_fifo_ptr == 0 && st_flag[data_pointer + 1]) begin 
                               receive_end <= 1'b1;
                               crc_reg <= data_inp[data_pointer * 8 + 7 -: 8];
                           end                               
                           else if (data_fifo_ptr == 1 && st_flag[data_pointer]) 
                               receive_end <= 1'b1;
                           else begin                               
                               fifo_data_o[data_fifo_ptr * 8 + 7 -: 8] <= data_inp[data_pointer * 8 + 7 -: 8];  
                               fifo_data_o[data_fifo_ptr * 8 + 15 -: 8] <= data_inp[(data_pointer + 1) * 8 + 7 -: 8];   
                               fifo_data_o[data_fifo_ptr * 8 + 23 -: 8] <= data_inp[(data_pointer + 2) * 8 + 7 -: 8];
                               if (data_fifo_ptr == 1) begin
                                   data_fifo_ptr <= 0;
                                   fifo_wren_o <= 1'b1;
                               end
                               else begin    
                                   fifo_wren_o <= 1'b0;
                                   data_fifo_ptr <= data_fifo_ptr + 3;
                               end                               
                               data_pointer <= data_pointer + 3;
                           end                               
                       end
                       // ------------------------------------------------------------------------------------
                       // add 2 bytes and send 4 bytes to FIFO if all 4 bytes collected                                                     
                       else if (LVDS_PIN_NUMBER - data_pointer >= 2 && data_fifo_ptr < 3) begin
                           if (data_fifo_ptr == 0 && st_flag[data_pointer + 1]) begin
                               crc_reg <= data_inp[data_pointer * 8 + 7 -: 8];
                               receive_end <= 1'b1;    
                           end
                           else if (data_fifo_ptr == 1 && st_flag[data_pointer])
                               receive_end <= 1'b1;
                           else begin
                               fifo_data_o[data_fifo_ptr * 8 + 7 -: 8] <= data_inp[data_pointer * 8 + 7 -: 8];  
                               fifo_data_o[data_fifo_ptr * 8 + 15 -: 8] <= data_inp[(data_pointer + 1) * 8 + 7 -: 8];
                               if (data_fifo_ptr == 2) begin
                                   data_fifo_ptr <= 0;
                                   fifo_wren_o <= 1'b1;
                               end
                               else begin    
                                   fifo_wren_o <= 1'b0;
                                   data_fifo_ptr <= data_fifo_ptr + 2;
                               end
                               data_pointer <= data_pointer + 2;
                           end                               
                       end            
                       // ------------------------------------------------------------------------------------
                       // add 1 byte and send 4 bytes to FIFO if all 4 bytes collected                                         
                       else if (LVDS_PIN_NUMBER - data_pointer >= 1 && data_fifo_ptr < 4) begin
                           if (st_flag[data_pointer]) 
                               receive_end <= 1'b1;
                           else begin                                
                               fifo_data_o[data_fifo_ptr * 8 + 7 -: 8] <= data_inp[data_pointer * 8 + 7 -: 8];
                               if (data_fifo_ptr == 3) begin
                                   data_fifo_ptr <= 0;
                                   fifo_wren_o <= 1'b1;
                               end
                               else begin    
                                   fifo_wren_o <= 1'b0;
                                   data_fifo_ptr <= data_fifo_ptr + 1;
                               end
                               data_pointer <= data_pointer + 1;
                               crc_reg <= data_inp[data_pointer * 8 + 7 -: 8];
                           end                               
                       end 
                       // ------------------------------------------------------------------------------------      
                    end 
                    // if receive end check crc and goes to SEND_RESPONSE state
                    else fifo_wren_o <= 1'b0;
                    if (receive_end && LVDS_PIN_NUMBER >= 2 && crc_reg == crc_7) begin
                        data_reg[7:0] <= 8'h7E;
                        data_reg[15:8] <= 8'h1;
                        st_flag_o <= 1;
                    end
                    // TODO: found little bug with crc. Fixing it.
//                    else if (receive_end && LVDS_PIN_NUMBER >= 2 && crc_reg != crc_7) begin
//                        data_reg[7:0] <= 8'h7E;
//                        data_reg[15:8] <= 8'h10;
//                        st_flag_o <= 1;
//                    end                                            
	       end
	   endcase	   
	end	
    // read new data from fifo 
	assign fifo_rden_o = !fifo_empty_ctrl_i && start_flg && !rest_num && data_pointer != LVDS_PIN_NUMBER;
	// flag to start work of serializers
	assign start_o = (state == SEND || (state == HANDSHAKE && load_hdshk && MASTER_SLAVE && !start_disable)
	                                || (state == HANDSHAKE && init_ready && !MASTER_SLAVE)) 
	                                || (state == SEND_RESPONSE && receive_end)? {LVDS_PIN_NUMBER{1'b1}} : 0;
	                                
	                                
      // TO DO: send it to another file
      // polynomial: (0 3 7)
      // data width: 32
      function [6:0] nextCRC7_D32;
    
        input [31:0] Data;
        input [6:0] crc;
        reg [31:0] d;
        reg [6:0] c;
        reg [6:0] newcrc;
      begin
        d = Data;
        c = crc;
    
        newcrc[0] = d[31] ^ d[30] ^ d[24] ^ d[23] ^ d[21] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^ d[14] ^ d[12] ^ d[8] ^ d[7] ^ d[4] ^ d[0] ^ c[5] ^ c[6];
        newcrc[1] = d[31] ^ d[25] ^ d[24] ^ d[22] ^ d[21] ^ d[19] ^ d[17] ^ d[16] ^ d[15] ^ d[13] ^ d[9] ^ d[8] ^ d[5] ^ d[1] ^ c[0] ^ c[6];
        newcrc[2] = d[26] ^ d[25] ^ d[23] ^ d[22] ^ d[20] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[10] ^ d[9] ^ d[6] ^ d[2] ^ c[0] ^ c[1];
        newcrc[3] = d[31] ^ d[30] ^ d[27] ^ d[26] ^ d[20] ^ d[19] ^ d[17] ^ d[16] ^ d[14] ^ d[12] ^ d[11] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[0] ^ c[1] ^ c[2] ^ c[5] ^ c[6];
        newcrc[4] = d[31] ^ d[28] ^ d[27] ^ d[21] ^ d[20] ^ d[18] ^ d[17] ^ d[15] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[1] ^ c[2] ^ c[3] ^ c[6];
        newcrc[5] = d[29] ^ d[28] ^ d[22] ^ d[21] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[13] ^ d[12] ^ d[10] ^ d[6] ^ d[5] ^ d[2] ^ c[3] ^ c[4];
        newcrc[6] = d[30] ^ d[29] ^ d[23] ^ d[22] ^ d[20] ^ d[19] ^ d[17] ^ d[15] ^ d[14] ^ d[13] ^ d[11] ^ d[7] ^ d[6] ^ d[3] ^ c[4] ^ c[5];
        nextCRC7_D32 = newcrc;
      end
      endfunction	                                
		
	endmodule
