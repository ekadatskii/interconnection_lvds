
`timescale 1 ns / 1 ps

//	module parallella_lvds_controller_v1_0 #
//	(
//		// Parameters of Axi Master Bus Interface M00_AXI
//		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
//		parameter integer C_M00_AXI_BURST_LEN	= 16,
//		parameter integer C_M00_AXI_ID_WIDTH	= 1,
//		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
//		parameter integer C_M00_AXI_DATA_WIDTH	= 32,
//		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
//		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
//		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
//		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
//		parameter integer C_M00_AXI_BUSER_WIDTH	= 0
//	)
//	(

//		// Ports of Axi Master Bus Interface M00_AXI
//		input wire  m00_axi_init_axi_txn,
//		output wire  m00_axi_txn_done,
//		output wire  m00_axi_error,
//		input wire  m00_axi_aclk,
//		input wire  m00_axi_aresetn,
//		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
//		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
//		output wire [7 : 0] m00_axi_awlen,
//		output wire [2 : 0] m00_axi_awsize,
//		output wire [1 : 0] m00_axi_awburst,
//		output wire  m00_axi_awlock,
//		output wire [3 : 0] m00_axi_awcache,
//		output wire [2 : 0] m00_axi_awprot,
//		output wire [3 : 0] m00_axi_awqos,
//		output wire [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
//		output wire  m00_axi_awvalid,
//		input wire  m00_axi_awready,
//		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
//		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
//		output wire  m00_axi_wlast,
//		output wire [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
//		output wire  m00_axi_wvalid,
//		input wire  m00_axi_wready,
//		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
//		input wire [1 : 0] m00_axi_bresp,
//		input wire [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
//		input wire  m00_axi_bvalid,
//		output wire  m00_axi_bready,
//		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
//		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
//		output wire [7 : 0] m00_axi_arlen,
//		output wire [2 : 0] m00_axi_arsize,
//		output wire [1 : 0] m00_axi_arburst,
//		output wire  m00_axi_arlock,
//		output wire [3 : 0] m00_axi_arcache,
//		output wire [2 : 0] m00_axi_arprot,
//		output wire [3 : 0] m00_axi_arqos,
//		output wire [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
//		output wire  m00_axi_arvalid,
//		input wire  m00_axi_arready,
//		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
//		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
//		input wire [1 : 0] m00_axi_rresp,
//		input wire  m00_axi_rlast,
//		input wire [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
//		input wire  m00_axi_rvalid,
//		output wire  m00_axi_rready
//	);

//TO DO: CRC, Resend packet
`timescale 1 ns / 1 ps

	module parallella_controller_v1_0 (
       input clk,   
       input reset,
       
      // output to Full Master 
       output [31:0] axi_awaddr_o,    
       output axi_awvalid_o,
       output [31:0] axi_wdata_o,
       output axi_wvalid_o,
       output [31:0] axi_araddr_o,
       output axi_arvalid_o,
       output axi_rready_o,
       output axi_wlast_o,
       output axi_bready_o,       
       
      // input from Full Master
       input axi_awready_i, 
       input axi_wready_i,
       input axi_arready_i, 
       input [31:0] axi_rdata_i,
       input axi_rvalid_i,
       input axi_rlast_i,
       input axi_bvalid_i,
       
       
      // Fake
       input [1:0] axi_bresp_i,
       input [1:0] axi_rresp_i,
      // axi full addition
       output reg axi_awid_o=0,
       output reg [7:0] axi_awlen_o = 15,
       output reg [2:0] axi_awsize_o = 2,
       output reg [1:0] axi_awburst_o = 1,
       output reg axi_awlock_o = 0,
       output reg [3:0] axi_awcache_o = 2,
       output reg [2:0] axi_awprot_o = 0,
       output reg [3:0] axi_awregion_o = 0,
       output reg [3:0] axi_awqos_o = 0,
       output reg [3:0] axi_wstrb_o = 15,
       output reg axi_arid_o = 0,
       output reg [7:0] axi_arlen_o = 15,
       output reg [2:0] axi_arsize_o = 2,
       output reg [1:0] axi_arburst_o = 1,
       output reg axi_arlock_o = 0,
       output reg [3:0] axi_arcache_o = 2,
       output reg [2:0] axi_arprot_o = 0,  
       output reg [3:0] axi_arregion_o = 0,  
       output reg [3:0] axi_arqos_o = 2,
//       input axi_bid,
//       input axi_rid,  
       
     // input from serdes
       input [36:0] data_i,
       input [1:0] lvds_busy,
   
      // output to serdes
       output [1:0] start_o,
       output [4:0] command_o,
       output [31:0] data_o 
               	
	);
   //receive command from axi	
	reg [66:0] data_reg = 0;
    always @(posedge clk)
    begin
        if (axi_awready_i) data_reg[0] <= axi_awready_i; 
        if (axi_wready_i)  data_reg[1] <= axi_wready_i;
        if (axi_arready_i) data_reg[2] <= axi_arready_i;
        if (axi_rvalid_i) begin
            data_reg[3] <= axi_rvalid_i;
            data_reg[35:4] <= axi_rdata_i;
            data_reg[36] <= axi_rlast_i;
        end         
    end
	reg last_data_delay;
	reg [2:0]  receive_flag;
	reg last_flag;
   // shows, that first respons was send
   // and it needs wait time for receiving next data 
	reg frst_resp_flag;
	reg [4:0]  inp_cmd;
	reg [31:0] inp_addr;
    reg [31:0] inp_data;
	reg [8:0]  checker;
	reg [2:0] send_flag;
	reg axi_send;
	
	always @(posedge clk)
	begin
	    if (data_i[4] && !data_i[3] && data_i[1] && data_i[0]) 
            inp_cmd <= data_i[4:0];                        
        else if (data_i[4] && !receive_flag[0]) 
        begin
            inp_cmd <= data_i[4:0];
            receive_flag[0] <= 1'b1;
        end 
	end	
		
   //state machine states	
	reg [7:0] state = 8'b00000001;
	localparam INIT = 8'b00000001;
    localparam WAIT = 8'b00000010;
    localparam RECEIVE_CMD = 8'b00000100;
    localparam RECEIVE_ADDR = 8'b00001000;
    localparam RECEIVE_DATA = 8'b00010000;
    localparam SEND_TO_AXI = 8'b00100000;
    localparam SEND_CMD  = 8'b01000000;
    localparam SEND_DATA = 8'b10000000;
    
    always @(posedge clk)
    begin: STATE_CHANGE
        case(state)
            INIT: begin
                state <= WAIT;
            end
            WAIT: begin
               // for Write                         
                if (data_i[4] && !data_i[3] && data_i[2] && !receive_flag[0])
                    state <= RECEIVE_ADDR;
                else if (frst_resp_flag && !receive_flag[2] && receive_flag[0])  
                    state <= RECEIVE_DATA;                   
                else if (frst_resp_flag && receive_flag[2] && receive_flag[0] && checker == 8) 
                begin
                    state <= RECEIVE_DATA;
                end
                else if (data_i[4] && !data_i[3] && !data_i[1] && data_i[0])
                    state <= SEND_TO_AXI;
               // for Read                     
                else if (data_i[4] && data_i[3] && data_i[2] && !receive_flag[0])
                    state <= RECEIVE_ADDR; 
                else if (inp_cmd[3] && inp_cmd[2] && send_flag[0] && !lvds_busy[1] && (!axi_rlast_i || last_flag))
                    state <= SEND_DATA; 
                else if (inp_cmd[3] && inp_cmd[2] && !lvds_busy[0] && axi_rlast_i && !last_flag) 
                    state <= SEND_CMD;                                                      
                                                                                                             
            end
            RECEIVE_CMD: begin
            end
            RECEIVE_ADDR: begin
                if(receive_flag[1] && !inp_cmd[3])
                    state <= RECEIVE_DATA;
                else if(receive_flag[1] && inp_cmd[3])
                    state <= SEND_TO_AXI;                      
            end
            RECEIVE_DATA: begin
                if(receive_flag[2])
                    state <= SEND_TO_AXI;
            end
            SEND_TO_AXI: begin
               // for Write
                if (!inp_cmd[3] && inp_cmd[0] && inp_cmd[1] && last_data_delay)
                    state <= SEND_CMD;
                else if (!inp_cmd[3] && inp_cmd[0] && !inp_cmd[1])  
                    state <= INIT;                  
                else if (!inp_cmd[3] && frst_resp_flag) 
                    state <= WAIT;
                else if (!inp_cmd[3] && inp_cmd[1] && axi_wready_i)
                    state <= SEND_CMD; 
               // for Read
                if (inp_cmd[3] && inp_cmd[2] && axi_arready_i && !send_flag[0])
                    state <= SEND_CMD;
                else if (inp_cmd[3] && data_reg[3] && !lvds_busy[1])
                    state <= SEND_DATA;                                       
                                                                                       
            end
            SEND_CMD: begin
                if (!inp_cmd[3] || lvds_busy[0]) state <= WAIT;
                else if (inp_cmd[3] && (axi_rvalid_i || data_reg[3]) && !lvds_busy[1] && !axi_rlast_i) 
                    state <= SEND_DATA;
                else if (inp_cmd[3] && (axi_rvalid_i || data_reg[3]) && !lvds_busy[1] && axi_rlast_i) 
                    state <= WAIT;                   
            end
            SEND_DATA: begin
//                if (lvds_busy[1])
                if (last_flag)
                    state <= INIT;
                else                    
                    state <= WAIT;
            end
        endcase               
    end	
	
    always @(posedge clk)
    begin: EXECUTION
        case(state)
            INIT: begin
                data_reg <= 0;
                receive_flag <= 0;
                frst_resp_flag <= 0;
                inp_cmd   <= 0;
                inp_addr  <= 0;
                inp_data  <= 0;
                checker   <= 0;
                stop_flag <= 0; 
                last_data_delay <= 0;
                send_flag <= 0;
                axi_send <= 0;  
                last_flag <= 0;         
            end
            WAIT: begin
                if (frst_resp_flag && !receive_flag[2])
                    checker <= 2'b10;               
                else if (frst_resp_flag && receive_flag[2] && checker == 8) begin
                    receive_flag[2] <= 1'b0;
                    checker <= 0;
                end 
                else if (frst_resp_flag)
                    checker <= checker + 1;                   
            end
            RECEIVE_CMD: begin
            end
            RECEIVE_ADDR: begin
                if (!receive_flag[1]) begin
                    if (checker == 27) begin 
                         inp_addr <= data_i[36:5];
                         stop_flag[0] <= 1'b0;
                         receive_flag[1] <= 1'b1;
                         checker <= 0;
                    end                                               
                    else checker <= checker + 1;
                end           
            end
            RECEIVE_DATA: begin
                if (!receive_flag[2]) begin 
                    if (checker == 32) begin
                        inp_data <= data_i[36:5];
                        stop_flag[1] <= 1'b0;
                        receive_flag[2] <= 1'b1;
                        checker <= 0;   
                    end     
                else checker <= checker + 1;
                end            
            end
            SEND_TO_AXI: begin
               // for Write
                if (!inp_cmd[3] && frst_resp_flag) begin
                    receive_flag[2] <= 1'b0;
                end                    
                if (!inp_cmd[3] && inp_cmd[2] && axi_awready_i) stop_flag[0] <= 1'b1;
                if (!inp_cmd[3] && inp_cmd[1] && axi_wready_i)  stop_flag[1] <= 1'b1;
                if (!inp_cmd[3] && inp_cmd[0] && inp_cmd[1] && !last_data_delay) 
                    last_data_delay <= 1'b1; 
               // for Read                    
                if (inp_cmd[3] && inp_cmd[2] && axi_arready_i) begin
                    stop_flag[0] <= 1'b1;
                    axi_send <= 1'b1;
                end                                                                   
            end
            SEND_CMD: begin
                if (!inp_cmd[3]) begin
                    if (axi_bvalid_i) begin
                        receive_flag[0] <= 0;
                        frst_resp_flag <= 1'b0;
                    end
                    else                    
                        frst_resp_flag <= 1'b1;
                end
                if (!lvds_busy[0]) send_flag[0] <= 1'b1; 
                if (!lvds_busy[0] && axi_rlast_i) last_flag <= 1'b1;                                       
            end
            SEND_DATA: begin
                if (!lvds_busy[1]) begin
                    send_flag[2] <= 1'b1;
                    axi_send <= 1'b0;
                    stop_flag[0] <= 1'b0;
                end                                                        
            end
        endcase               
    end 
    
    reg [2:0] stop_flag;
	assign axi_awvalid_o = (!inp_cmd[3] && state == 7'b0100000 && !stop_flag[0]) ? inp_cmd[2] : 0;
    assign axi_wvalid_o = (!inp_cmd[3] && state == 7'b0100000 && !stop_flag[1]) ? inp_cmd[1] : 0;
    assign axi_wlast_o = (!inp_cmd[3] && state == 7'b0100000) ? inp_cmd[0] && inp_cmd[1] && last_data_delay : 0;
    assign axi_awaddr_o = inp_addr;
    assign axi_wdata_o = inp_data;
    assign axi_bready_o = !inp_cmd[3] && !inp_cmd[1] && inp_cmd[0] && axi_bvalid_i;
    assign axi_arvalid_o = inp_cmd[3] && state == 7'b0100000 && !stop_flag[0]; 
    assign axi_araddr_o = inp_addr;
    assign axi_rready_o = state == 8'b10000000 && axi_rvalid_i;
        
    assign start_o[0] = (state == 8'b01000000) ? 1'b1 : 0;
    assign start_o[1] = (state == 8'b10000000) ? 1'b1 : 0;
                                           
    assign command_o = (state == 7'b1000000 && axi_bvalid_i)  ? {1'b1, 1'b0, 1'b0, 1'b0, 1'b1} :
                       (state == 7'b1000000 && data_reg[0] && data_reg[1])  ? {1'b1, 1'b0, data_reg[0], data_reg[1], 1'b0} : 
                       (state == 7'b1000000 && (axi_rvalid_i || data_reg[3])) ? {1'b1, 1'b1, data_reg[2], data_reg[3] || axi_rvalid_i, data_reg[36]} :
                                                              0; 
    assign data_o = (state == 8'b10000000 ) ? data_reg[35:4] : 0;                                                                           

	endmodule