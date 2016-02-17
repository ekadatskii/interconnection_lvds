
//`timescale 1 ns / 1 ps

//	module parsboard_lvds_controller_v1_0 #
//	(
//		// Users to add parameters here

//		// User parameters ends
//		// Do not modify the parameters beyond this line


//		// Parameters of Axi Slave Bus Interface S00_AXI
//		parameter integer C_S00_AXI_ID_WIDTH	= 1,
//		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
//		parameter integer C_S00_AXI_ADDR_WIDTH	= 6,
//		parameter integer C_S00_AXI_AWUSER_WIDTH	= 0,
//		parameter integer C_S00_AXI_ARUSER_WIDTH	= 0,
//		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
//		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
//		parameter integer C_S00_AXI_BUSER_WIDTH	= 0
//	)
//	(
//		// Users to add ports here

//		// User ports ends
//		// Do not modify the ports beyond this line


//		// Ports of Axi Slave Bus Interface S00_AXI
//		input wire  s00_axi_aclk,
//		input wire  s00_axi_aresetn,
//		input wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid,
//		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
//		input wire [7 : 0] s00_axi_awlen,
//		input wire [2 : 0] s00_axi_awsize,
//		input wire [1 : 0] s00_axi_awburst,
//		input wire  s00_axi_awlock,
//		input wire [3 : 0] s00_axi_awcache,
//		input wire [2 : 0] s00_axi_awprot,
//		input wire [3 : 0] s00_axi_awqos,
//		input wire [3 : 0] s00_axi_awregion,
//		input wire [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser,
//		input wire  s00_axi_awvalid,
//		output wire  s00_axi_awready,
//		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
//		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
//		input wire  s00_axi_wlast,
//		input wire [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser,
//		input wire  s00_axi_wvalid,
//		output wire  s00_axi_wready,
//		output wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid,
//		output wire [1 : 0] s00_axi_bresp,
//		output wire [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser,
//		output wire  s00_axi_bvalid,
//		input wire  s00_axi_bready,
//		input wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid,
//		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
//		input wire [7 : 0] s00_axi_arlen,
//		input wire [2 : 0] s00_axi_arsize,
//		input wire [1 : 0] s00_axi_arburst,
//		input wire  s00_axi_arlock,
//		input wire [3 : 0] s00_axi_arcache,
//		input wire [2 : 0] s00_axi_arprot,
//		input wire [3 : 0] s00_axi_arqos,
//		input wire [3 : 0] s00_axi_arregion,
//		input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser,
//		input wire  s00_axi_arvalid,
//		output wire  s00_axi_arready,
//		output wire [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid,
//		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
//		output wire [1 : 0] s00_axi_rresp,
//		output wire  s00_axi_rlast,
//		output wire [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser,
//		output wire  s00_axi_rvalid,
//		input wire  s00_axi_rready
//	);
    



`timescale 1 ns / 1 ps

	module parsboard_lvds_controller_v1_0 #
	(
		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 1,
//		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
//		parameter integer C_S00_AXI_ADDR_WIDTH	= 6,
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0
	)
	(
     input clk,
     input reset,       
     
    // input from Full Master 
     input [31:0] axi_awaddr_i,    
     input axi_awvalid_i,
     input [31:0] axi_wdata_i,
     input axi_wvalid_i,
     input [31:0] axi_araddr_i,
     input axi_arvalid_i,
     input axi_rready_i,
     input axi_wlast_i,
     input axi_bready_i,
     
     
    // output to Full Master
     output axi_awready_o, 
     output axi_wready_o,
     output axi_bvalid_o,     
     output axi_arready_o, 
     output [31:0] axi_rdata_o,
     output axi_rlast_o,
     output axi_rvalid_o,
     
    // Fake
     output reg [1:0] axi_bresp_o=0,
     output reg [1:0] axi_rresp_o=0,
     
    // Empty
     input axi_awid_i,
     input [7:0] axi_awlen_i,
     input [2:0] axi_awsize_i,
     input [1:0] axi_awburst_i,
     input axi_awlock_i,       
     input [3:0] axi_awcache_i, 
     input [2:0] axi_awprot_i, 
     input [3:0] axi_awqos_i,  
     input [3:0] axi_wstrb_i,  
     output reg axi_bid=0,
     input axi_arid_i,
     input [7:0] axi_arlen_i,   
     input [2:0] axi_arsize_i,
     input [1:0] axi_arburst_i,
     input axi_arlock_i, 
     input [3:0] axi_arcache_i,
     input [2:0] axi_arprot_i, 
     input [3:0] axi_arqos_i, 
     output reg rid=0,
     
    // input from serdes
     input [36:0] data_i,
     input [1:0] lvds_busy,
     
    // output to serdes
     output [1:0] start_o,
     output [4:0] command_o,
     output [31:0] data_o 
	);
	
   // write input from AXI to register
    reg [68:0] data_reg = 0;    
	always @(posedge clk)
	begin
        if (axi_awvalid_i) begin
            data_reg[0]     <= axi_awvalid_i;
            data_reg[34:3]  <= axi_awaddr_i;
        end	   
        if (axi_wvalid_i) begin            
            data_reg[1]     <=  axi_wvalid_i;
            data_reg[2]     <=   axi_wlast_i;
            data_reg[66:35] <=   axi_wdata_i;
        end
        if (axi_bready_i) 
            data_reg[67] <= axi_bready_i;
        if (axi_arvalid_i) begin
            data_reg[68] <= axi_arvalid_i;
            data_reg[34:3] <= axi_araddr_i;
        end            
                                
	end

   // received command/address/data
	reg [2:0] receive_flag;	
   // command read from lvds 	
    reg [4:0] inp_cmd;
    reg [31:0] inp_data;
    reg [8:0] checker;
    always @(posedge clk)  
    begin
        if (data_i[4] && data_i[0])
            inp_cmd <= data_i[4:0];
        else if (data_i[4] && !receive_flag[0]) begin
            inp_cmd <= data_i[4:0];
            receive_flag[0] <= 1'b1;
        end        
    end 
    
   // sended command/address/data 
   	reg [2:0] send_flag;
   // last data   	
   	reg last_flag; 
   	
   	reg first_data_receive;		    
	
   // state machine states:
    reg [6:0] state = 7'b0000001;
    localparam INIT = 7'b0000001;
    localparam WAIT = 7'b0000010;
    localparam SEND_CMD = 7'b0000100;
    localparam SEND_ADDR = 7'b0001000;
    localparam SEND_DATA = 7'b0010000;
    localparam SEND_TO_AXI = 7'b0100000;
    localparam RECEIVE_DATA = 7'b1000000;
    
    always @(posedge clk)
    begin: STATE_CHANGE
        case(state)
            INIT: begin
                state <= WAIT;
            end
            WAIT: begin
               // for write 
                if (data_reg[0] && data_reg[1] && !lvds_busy[0] && !send_flag[0]) //add busy lvds
                    state <= SEND_CMD;
                else if (data_reg[0] && data_reg[1]  && data_reg[2] && !lvds_busy[0] && !last_flag)  
                    state <= SEND_CMD;
                else if (!inp_cmd[3] && inp_cmd[0] && !lvds_busy[0] && !send_flag[0])
                    state <= SEND_CMD;                                      
                else if (data_reg[0] && send_flag[0] && !lvds_busy[1] && !send_flag[1])
                    state <= SEND_ADDR;
                else if (data_reg[1] && send_flag[1] && !lvds_busy[1] && !send_flag[2])
                    state <= SEND_DATA;
                else if ((data_i[4] && !data_i[3]) || (inp_cmd[4] && !inp_cmd[3]) && !receive_flag[0])
                    state <= SEND_TO_AXI;
                else if (!data_i[3] && data_i[4] && data_i[0])
                    state <= SEND_TO_AXI;  
               // for read 
                if (data_reg[68] && !lvds_busy[0] && !send_flag[0])
                    state <= SEND_CMD;                    
                else if (data_i[3] && data_i[2] && !receive_flag[0])
                    state <= SEND_TO_AXI;  
                else if (inp_cmd[3] && inp_cmd[2] && axi_rready_i && checker == 4 || (checker == 3 && !first_data_receive))
                    state <= RECEIVE_DATA;                                      
            end
            SEND_CMD: begin
               // for write 
                if (lvds_busy[0]) 
                    state <= WAIT;                    
                else if (data_reg[0] && !lvds_busy[1] && !send_flag[1])
                    state <= SEND_ADDR;
                else if (data_reg[1] && data_reg[2] && !lvds_busy[1] && !send_flag[2])
                    state <= SEND_DATA; 
                else if (data_reg[67])
                    state <= INIT;
               // for read 
                else if (data_reg[68])
                    state <= SEND_ADDR;                                                           
            end
            SEND_ADDR: begin
                if (lvds_busy[0])
                    state <= WAIT;
                if (data_reg[1] && !lvds_busy[1] && !send_flag[2])
                    state <= SEND_DATA;
               // for read
                if (data_reg[68] && !lvds_busy[1] && !send_flag[2])
                    state <= WAIT;                     
            end 
            SEND_DATA: begin
                state <= WAIT;
            end 
            SEND_TO_AXI: begin
                if (!inp_cmd[3] && inp_cmd[1] && axi_wvalid_i)
                    state <= WAIT;
                else if (!inp_cmd[3] && inp_cmd[0] && axi_bready_i)
                    state <= WAIT;
               // for Read
                else if (inp_cmd[3] && last_flag) 
                    state <= INIT;                   
                else if (inp_cmd[3] && inp_cmd[1] && !receive_flag[1])
                    state <= RECEIVE_DATA;
                else if (inp_cmd[3] && inp_cmd[1] && axi_rready_i)
                    state <= WAIT;                        
            end
            RECEIVE_DATA: begin
                if (receive_flag[2])
                    state <= SEND_TO_AXI;                
            end          
        endcase            
    end    
    
    always @(posedge clk)
    begin: EXECUTION
        case(state)
            INIT: begin
                data_reg <= 0; 
                inp_cmd <= 0; 
                send_flag <= 0;
                receive_flag <= 0;
                stop_flag <= 0;
                last_flag <= 0;
                inp_data <= 0;
                checker <= 0;
                first_data_receive <= 0;            
            end
            WAIT: begin
                if (inp_cmd[3] && inp_cmd[2] && axi_rready_i) begin
                    if ((checker == 3 && !first_data_receive) || checker == 4) begin
                        checker <= 0; 
                        first_data_receive <= 1'b1;
                    end                                
                    else
                        checker <= checker + 1;
                end                                        
            end
            SEND_CMD: begin
                if (!lvds_busy[0]) send_flag[0] <= 1'b1;
                if (data_reg[2]) last_flag <= 1'b1;
            end
            SEND_ADDR: begin
                if (!lvds_busy[1])
                    send_flag[1] <= 1'b1;
            end 
            SEND_DATA: begin
                if (!lvds_busy[1]) begin
                    send_flag[2] <= 1'b1;
                    receive_flag[0] <= 1'b0;
                end                    
            end 
            SEND_TO_AXI: begin
               // for Write
                if (!inp_cmd[3] && inp_cmd[1] && axi_wvalid_i) begin
                    send_flag[2] <= 1'b0;
                    receive_flag[0] <= 1'b1;
                end
                if (data_reg[2]) data_reg <= 0;
                if (!inp_cmd[3] && inp_cmd[0] && axi_bready_i)
                    send_flag[0] <= 1'b0; 
               // for Read                    
                if (inp_cmd[3] && inp_cmd[2]) begin 
                    receive_flag[1] <= 1'b1;
                    receive_flag[2] <= 1'b0;
                end
                if (inp_cmd[3] && inp_cmd[2] && inp_cmd[0])
                    last_flag <= 1'b1;                    
//                if(inp_cmd[3] && inp_cmd[1] && axi_rready_i)
//                    first_data_receive <= 1'b1;                                                                        
            end
            RECEIVE_DATA: begin
                if (!receive_flag[2]) begin
                    if (checker == 26) begin
                        inp_data <= data_i[36:5];
                        receive_flag[2] <= 1'b1;
                        checker <= 0;
                    end
                    else checker <= checker + 1;                                                                                                            
                end                    
                
            end          
        endcase            
    end

   // send axi full command
   // command format : [start_bit{1}; write{0} or read{1}; addr valid; data valid; last]
    assign command_o = // for write
                       (data_reg[0] && data_reg[1] && state == 6'b000100) ? {1'b1, 1'b0, data_reg[0], data_reg[1], data_reg[2]} : 
                       (data_reg[67] && state == 6'b000100) ? {1'b1, 1'b0, 1'b0, 1'b0, 1'b1} :
                       // for read
                       (data_reg[68] && state == 6'b000100) ? {1'b1, 1'b1, data_reg[68], 1'b0, 1'b0} :
                                                                            0;
   //address or data send 
    assign data_o  = (state == 6'b001000) ? data_reg[34:3] :  //addr
                     (state == 6'b010000) ? data_reg[66:35]:  //data                                                            
                                            0;
    assign start_o[0] = (state == 6'b000100 && !lvds_busy[0]) ? 1'b1 : 0;      //cmd                                     
    assign start_o[1] = (state == 6'b001000 && !lvds_busy[1]) ? 1'b1        :  //addr
                        (state == 6'b010000 && !lvds_busy[1]) ? 1'b1        :  //data
                                                             0;    
    // send response to AXI 
    reg [2:0] stop_flag;                                                                 
    assign axi_awready_o = (!inp_cmd[3] && inp_cmd[2] && state == 6'b100000) ? inp_cmd[2] : 0;
    assign axi_wready_o = (!inp_cmd[3] && inp_cmd[1] && state == 6'b100000) ? inp_cmd[1] : 0;
    assign axi_bvalid_o = (!inp_cmd[3] && inp_cmd[0] && state == 6'b100000) ? inp_cmd[0] : 0;
    assign axi_arready_o = (inp_cmd[3] && inp_cmd[2] && state == 6'b100000 && !receive_flag[1]) ? inp_cmd[2] : 0; //take not receive flag                                                                                      
    assign axi_rvalid_o = (inp_cmd[3] && inp_cmd[1] && state == 6'b100000 && receive_flag[1]) ? inp_cmd[1] : 0;
    assign axi_rlast_o = (inp_cmd[3] && inp_cmd[0] && last_flag && state == 6'b100000) ? inp_cmd[0] : 0;
    assign axi_rdata_o = inp_data; 
                                                                                  
	endmodule
   