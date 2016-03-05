
`timescale 1 ns / 1 ps

	module fifo_serdes #
	(
	   parameter FIFO_DEPTH = 10,
	   parameter DATA_WIDTH = 32
	)
	(
	   // Common ports
	   // fast for serdes part
       // slow for AXI part
	   input clk_fast,
	   input clk_slow,
	   input reset, // active low
	   
	   output [DATA_WIDTH - 1 : 0] data_o,
	   // for SERDES to AXI && AXI to SERDES sides
	   output fifo_full_axi,
	   output fifo_full_ctrl,	   
	   output fifo_empty_axi,
	   output fifo_empty_ctrl,
	   
	   // Just for testing with AXI Stream
	   output ready_stream,
	   input tvalid_i,
	   
	   input [DATA_WIDTH - 1 : 0] data_i,
	   // fast/slow will be used in future
	   // when frequencies of SERDES and AXI
	   // will be different. 
	   input rd_en_fast,
	   input rd_en_slow,
	   input wr_en_fast,
	   input wr_en_slow,
	   // used for continue read data with SERDES
	   // or resend data again
	   input [3:0] fifo_command_i
	);
	
    // function called clogb2 that returns an integer which has the 
    // value of the ceiling of the log base 2.
    function integer clogb2 (input integer bit_depth);
      begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
          bit_depth = bit_depth >> 1;
      end
    endfunction
    localparam ADDR_WIDTH = clogb2(FIFO_DEPTH);
    
	reg [DATA_WIDTH - 1 : 0] data_reg [0 : FIFO_DEPTH - 1];
	// Pointers for sending data from axi to serdes (axsrd)
	reg [ADDR_WIDTH-1 : 0] axsrd_rd_ptr_first;
	reg [ADDR_WIDTH-1 : 0] axsrd_rd_ptr;
	reg [ADDR_WIDTH-1 : 0] axsrd_wr_ptr_prev;
    reg [ADDR_WIDTH-1 : 0] axsrd_wr_ptr;
    // Pointers for sending data from serdes to axi (srdax)
	reg [ADDR_WIDTH-1 : 0] srdax_rd_ptr_first;
	reg [ADDR_WIDTH-1 : 0] srdax_rd_ptr;
	reg [ADDR_WIDTH-1 : 0] srdax_wr_ptr_prev;
    reg [ADDR_WIDTH-1 : 0] srdax_wr_ptr;
        
    reg fifo_full_axi;
    reg fifo_full_ctrl;
    reg fifo_empty_axi;
    reg fifo_empty_ctrl;
	
	always @(posedge clk_slow)
	begin
	   if (!reset) begin
	       axsrd_rd_ptr_first <= 0; 
           axsrd_wr_ptr_prev <= 0;	 
           axsrd_wr_ptr <= 0; 
           srdax_rd_ptr <= 0;     
           fifo_full_axi <= 0;
           fifo_empty_axi <= 1;
	   end
	   else begin
	       // Write to FIFO from AXI
	       if (wr_en_slow && !fifo_full_axi) 
	       begin
	           data_reg[axsrd_wr_ptr] <= data_i;
	           axsrd_wr_ptr_prev <= axsrd_wr_ptr;              
	           axsrd_wr_ptr <= (axsrd_wr_ptr + 1) % FIFO_DEPTH;	               
	       end
	       // FIFO full flag control when write from AXI enabled
           if (((axsrd_wr_ptr + 1) % FIFO_DEPTH == axsrd_rd_ptr_first && wr_en_slow)
                   || ((axsrd_wr_ptr_prev + 1) % FIFO_DEPTH == axsrd_rd_ptr_first))
               fifo_full_axi <= 1'b1;
           else 
               fifo_full_axi <= 1'b0;	       
	   end
	end

	always @(posedge clk_fast)
	begin
	   if (!reset) begin
           srdax_rd_ptr_first <= 0;
           srdax_wr_ptr_prev <= 0;     
           srdax_wr_ptr <= 0;
           axsrd_rd_ptr <= 0;      
           fifo_full_ctrl <= 0;
           fifo_empty_ctrl <= 1;
       end
       else begin
           // Read from FIFO to SERDES
           if (rd_en_fast && !fifo_empty_ctrl)
           begin
               axsrd_rd_ptr <= (axsrd_rd_ptr + 1) % FIFO_DEPTH;                           
           end           
           // Write from SERDES to FIFO
           if (wr_en_fast && !fifo_full_ctrl) 
           begin
               data_reg[srdax_wr_ptr] <= data_i;
               srdax_wr_ptr_prev <= srdax_wr_ptr;              
               srdax_wr_ptr <= (srdax_wr_ptr + 1) % FIFO_DEPTH;                   
           end            
	       // FIFO full flag control when write from SERDES enabled
	       if (((srdax_wr_ptr + 1) % FIFO_DEPTH == srdax_rd_ptr_first && wr_en_fast)
                   || ((srdax_wr_ptr_prev + 1) % FIFO_DEPTH == srdax_rd_ptr_first))
               fifo_full_ctrl <= 1'b1;
           else 
               fifo_full_ctrl <= 1'b0;                      

	       // FIFO empty flag control when read from FIFO to SERDES            
           if ((axsrd_wr_ptr == axsrd_rd_ptr && (!wr_en_slow || fifo_full_axi)) || 
               ((axsrd_rd_ptr + 1) % FIFO_DEPTH == axsrd_wr_ptr && rd_en_fast))
               fifo_empty_ctrl <= 1'b1;
           else 
               fifo_empty_ctrl <= 1'b0;                          
       end
       // If crc checked and right, continue read
       // new data from FIRO to SERDES
       if (fifo_command_i == 1) begin
           axsrd_rd_ptr_first <= axsrd_rd_ptr; 
           axsrd_wr_ptr_prev <= axsrd_wr_ptr;       
           fifo_full_axi <= 0;
       end
       // If crc checked and wrong, will resend the data
       else if (fifo_command_i == 2) begin
           axsrd_rd_ptr <= axsrd_rd_ptr_first; 
       end	   
	end
	// select data output for SERDES/AXI
	assign data_o = (rd_en_fast) ? data_reg[axsrd_rd_ptr] :
	                (rd_en_slow) ? data_reg[srdax_rd_ptr] : 0;
	
	// Just for testing with axi stream
	assign ready_stream = !fifo_full_axi && tvalid_i;
	

	endmodule
