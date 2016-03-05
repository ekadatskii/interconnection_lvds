`timescale 1ns / 1ps

    module deserializer_8b (
        input clk,
        input reset,
        input serial_i,
        output st_flag,
        output [7:0] data_o
    );
    reg [9:0] data_reg;
     
    decoder dec_00(
        .datain(data_reg),
        .dataout(data_o),
        .dispout(),
        .code_err(),
        .disp_err()
    );
   
    reg [2:0] state      = 3'b001; 
    parameter INIT       = 3'b001;   
    parameter READ_DATA  = 3'b010;
    
    
    always @ (posedge clk)
    begin: STATE_MASHINE
          case(state)
            INIT: begin  
                state <= READ_DATA;    
            end    
          endcase
    end
    
    always @ (posedge clk)
    begin: EX
          case(state)
            INIT: begin
                data_reg <= 0;                                
            end
            READ_DATA: begin        
                data_reg <= {data_reg, 1'b0};
                data_reg[0] <= serial_i;                          
            end                  
        endcase     
    end     
    
    // flag erase when start/stop of the frame cathed
    assign st_flag = (data_reg == 10'h7E) ? 1'b1 : 1'b0;
     
    endmodule
    
