`timescale 1ns / 1ps

    module serializer_8b (
        input clk,
        input reset,
        input [7:0] data_i,
        input start_i,
        input st_flag,
        output lvds_busy,
        output serial_o
    );
    // Data encoder
    wire [9:0] encoded_data;
    encode enc_00 (
        .datain(data_i), 
        .dataout(encoded_data), 
        .dispout()
    );
     
    reg lvds_busy;
    reg [4:0] checker;
    reg [9:0] frame;
    reg [7:0] data_reg;
    reg start;
    
    // STATE MASHINE   
    reg [1:0] state = 2'b01;    
    localparam INIT =        2'b01;
    localparam FRAME_SEND =   2'b10;
    
    always @ (posedge clk)
    begin: STATE_MASHINE
        case(state)
            
        INIT: begin
            state <= FRAME_SEND;                 
        end
                
        FRAME_SEND: begin
            if (checker == 8) state <= INIT;  //In old version checker == 9
        end 
                  
        endcase
    end  
    // Old version(11 clk for 8 bit)
    //assign serial_o = frame[9];
    // New version(10 clk for 8 bit)
    assign serial_o = (start_i && !st_flag && checker == 0) ? encoded_data[9] :
                                                              frame[9]; 
    
    always @ (posedge clk)
    begin: EX
        case(state)
        
        INIT: begin
            checker <= 0;
            frame <= 0;  
            start <= 0; 
            lvds_busy <= 0;             
        end 
                   
        FRAME_SEND: begin
            if (start_i && checker == 0) begin
                // begin/end of frame(0x7E) send without encode                   
                //if (!st_flag) frame <= encoded_data; //Old version
                if (!st_flag) frame <= {encoded_data, 1'b0}; //New version
                //else frame <= {2'b0,data_i}; //Old version
                else frame <= {1'b0,data_i,1'b0}; //New version
                start <= 1;
                lvds_busy <= 1;
            end                    
            else if (start)
                frame <= {frame, 1'b0}; 
            
            // TODO: check it. May be start_i && checker == 0 - useless code           
            if ((start_i && checker == 0) | start) 
                checker <= checker + 1;           
            if (checker == 8) lvds_busy <= 0; //In old version checker == 9                                                                                                                      
            end
            
        endcase
    end       
     
    endmodule
    
