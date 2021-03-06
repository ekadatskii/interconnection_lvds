`timescale 1ns / 1ps

    module deserializer_32bit (
        input clk,
        input reset,
        input serial_i,
        output reg [31:0] data_o
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
                data_o <= 0;                                
            end
            READ_DATA: begin        
                data_o <= {data_o, 1'b0};
                data_o[0] <= serial_i;                          
            end                  
        endcase     
    end     
     
     
    endmodule
    
