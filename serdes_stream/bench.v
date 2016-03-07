`timescale 1ns / 1ps

module bench();

reg clk;

initial begin
  clk = 1'b0;
  
  forever begin
    clk = #5 ~clk;
  end
end


design_1_wrapper design_1_wrapper_i
       (.clk(clk));  
//design_2_wrapper design_2_wrapper_i
//              (.clk(clk));          
endmodule
