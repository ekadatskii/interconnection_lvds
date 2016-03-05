
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I clk ]

  # Create instance: clk_gen_0, and set properties
  set clk_gen_0 [ create_bd_cell -type ip -vlnv user.org:user:clk_gen:1.0 clk_gen_0 ]

  # Create instance: fifo_serdes_0, and set properties
  set fifo_serdes_0 [ create_bd_cell -type ip -vlnv user.org:user:fifo_serdes:1.0 fifo_serdes_0 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {10} \
 ] $fifo_serdes_0

  # Create instance: fifo_serdes_1, and set properties
  set fifo_serdes_1 [ create_bd_cell -type ip -vlnv user.org:user:fifo_serdes:1.0 fifo_serdes_1 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {10} \
 ] $fifo_serdes_1

  # Create instance: serdes_lvds_0, and set properties
  set serdes_lvds_0 [ create_bd_cell -type ip -vlnv user.org:user:serdes_lvds:1.0 serdes_lvds_0 ]

  # Create instance: serdes_lvds_1, and set properties
  set serdes_lvds_1 [ create_bd_cell -type ip -vlnv user.org:user:serdes_lvds:1.0 serdes_lvds_1 ]

  # Create instance: stream_controller_0, and set properties
  set stream_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:stream_controller:1.0 stream_controller_0 ]
  set_property -dict [ list \
CONFIG.LVDS_PIN_NUMBER {23} \
 ] $stream_controller_0

  # Create instance: stream_controller_1, and set properties
  set stream_controller_1 [ create_bd_cell -type ip -vlnv user.org:user:stream_controller:1.0 stream_controller_1 ]
  set_property -dict [ list \
CONFIG.LVDS_PIN_NUMBER {23} \
CONFIG.MASTER_SLAVE {0} \
 ] $stream_controller_1

  # Create instance: stream_master_0, and set properties
  set stream_master_0 [ create_bd_cell -type ip -vlnv user.org:user:stream_master:1.0 stream_master_0 ]
  set_property -dict [ list \
CONFIG.INITIAL_NUMBER {2074861569} \
CONFIG.ITERATION_NUMBER {1} \
CONFIG.NUMBER_OF_OUTPUT_WORDS {3} \
 ] $stream_master_0

  # Create instance: stream_slave_1, and set properties
  set stream_slave_1 [ create_bd_cell -type ip -vlnv user.org:user:stream_slave:1.0 stream_slave_1 ]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins clk_gen_0/clk]
  connect_bd_net -net clk_gen_0_clk_serdes [get_bd_pins clk_gen_0/clk_serdes] [get_bd_pins fifo_serdes_0/clk_fast] [get_bd_pins fifo_serdes_0/clk_slow] [get_bd_pins fifo_serdes_1/clk_fast] [get_bd_pins fifo_serdes_1/clk_slow] [get_bd_pins serdes_lvds_0/clk] [get_bd_pins serdes_lvds_1/clk] [get_bd_pins stream_controller_0/clk] [get_bd_pins stream_controller_1/clk] [get_bd_pins stream_master_0/m_axis_aclk] [get_bd_pins stream_slave_1/s_axis_aclk]
  connect_bd_net -net clk_gen_0_res [get_bd_pins clk_gen_0/res] [get_bd_pins stream_controller_0/reset] [get_bd_pins stream_controller_1/reset]
  connect_bd_net -net clk_gen_0_res_n [get_bd_pins clk_gen_0/res_n] [get_bd_pins fifo_serdes_0/reset] [get_bd_pins fifo_serdes_1/reset] [get_bd_pins stream_master_0/m_axis_aresetn] [get_bd_pins stream_slave_1/s_axis_aresetn]
  connect_bd_net -net fifo_serdes_0_data_o [get_bd_pins fifo_serdes_0/data_o] [get_bd_pins stream_controller_0/fifo_data_i]
  connect_bd_net -net fifo_serdes_0_fifo_empty [get_bd_pins fifo_serdes_0/fifo_empty_ctrl] [get_bd_pins stream_controller_0/fifo_empty_ctrl_i]
  connect_bd_net -net fifo_serdes_0_fifo_empty_axi [get_bd_pins fifo_serdes_0/fifo_empty_axi] [get_bd_pins stream_controller_0/fifo_empty_axi_i]
  connect_bd_net -net fifo_serdes_0_fifo_full_axi [get_bd_pins fifo_serdes_0/fifo_full_axi] [get_bd_pins stream_controller_0/fifo_full_axi_i]
  connect_bd_net -net fifo_serdes_0_fifo_full_ctrl [get_bd_pins fifo_serdes_0/fifo_full_ctrl] [get_bd_pins stream_controller_0/fifo_full_ctrl_i]
  connect_bd_net -net fifo_serdes_0_ready_stream [get_bd_pins fifo_serdes_0/ready_stream] [get_bd_pins stream_master_0/m_axis_tready]
  connect_bd_net -net fifo_serdes_1_fifo_empty_axi [get_bd_pins fifo_serdes_1/fifo_empty_axi] [get_bd_pins stream_controller_1/fifo_empty_axi_i]
  connect_bd_net -net fifo_serdes_1_fifo_empty_ctrl [get_bd_pins fifo_serdes_1/fifo_empty_ctrl] [get_bd_pins stream_controller_1/fifo_empty_ctrl_i]
  connect_bd_net -net fifo_serdes_1_fifo_full [get_bd_pins fifo_serdes_1/fifo_full_ctrl] [get_bd_pins stream_controller_1/fifo_full_ctrl_i]
  connect_bd_net -net fifo_serdes_1_fifo_full_axi [get_bd_pins fifo_serdes_1/fifo_full_axi] [get_bd_pins stream_controller_1/fifo_full_axi_i]
  connect_bd_net -net serdes_lvds_0_data_o [get_bd_pins serdes_lvds_0/data_o] [get_bd_pins stream_controller_0/data_i]
  connect_bd_net -net serdes_lvds_0_lvds_busy [get_bd_pins serdes_lvds_0/lvds_busy] [get_bd_pins stream_controller_0/lvds_busy]
  connect_bd_net -net serdes_lvds_0_serial_o [get_bd_pins serdes_lvds_0/serial_o] [get_bd_pins serdes_lvds_1/serial_i]
  connect_bd_net -net serdes_lvds_0_st_flag_o [get_bd_pins serdes_lvds_0/st_flag_o] [get_bd_pins stream_controller_0/st_flag_i]
  connect_bd_net -net serdes_lvds_1_data_o [get_bd_pins serdes_lvds_1/data_o] [get_bd_pins stream_controller_1/data_i]
  connect_bd_net -net serdes_lvds_1_lvds_busy [get_bd_pins serdes_lvds_1/lvds_busy] [get_bd_pins stream_controller_1/lvds_busy]
  connect_bd_net -net serdes_lvds_1_serial_o [get_bd_pins serdes_lvds_0/serial_i] [get_bd_pins serdes_lvds_1/serial_o]
  connect_bd_net -net serdes_lvds_1_st_flag_o [get_bd_pins serdes_lvds_1/st_flag_o] [get_bd_pins stream_controller_1/st_flag_i]
  connect_bd_net -net stream_controller_0_data_o [get_bd_pins serdes_lvds_0/data_i] [get_bd_pins stream_controller_0/data_reg]
  connect_bd_net -net stream_controller_0_fifo_command_o [get_bd_pins fifo_serdes_0/fifo_command_i] [get_bd_pins stream_controller_0/fifo_command_o]
  connect_bd_net -net stream_controller_0_s_axi_tready [get_bd_pins fifo_serdes_0/rd_en_fast] [get_bd_pins stream_controller_0/fifo_rden_o]
  connect_bd_net -net stream_controller_0_st_flag [get_bd_pins serdes_lvds_0/st_flag_i] [get_bd_pins stream_controller_0/st_flag_o]
  connect_bd_net -net stream_controller_0_start_o [get_bd_pins serdes_lvds_0/start_i] [get_bd_pins stream_controller_0/start_o]
  connect_bd_net -net stream_controller_1_data_o [get_bd_pins serdes_lvds_1/data_i] [get_bd_pins stream_controller_1/data_reg]
  connect_bd_net -net stream_controller_1_fifo_command_o [get_bd_pins fifo_serdes_1/fifo_command_i] [get_bd_pins stream_controller_1/fifo_command_o]
  connect_bd_net -net stream_controller_1_fifo_wren_o [get_bd_pins fifo_serdes_1/wr_en_fast] [get_bd_pins stream_controller_1/fifo_wren_o]
  connect_bd_net -net stream_controller_1_m_axis_tdata [get_bd_pins fifo_serdes_1/data_i] [get_bd_pins stream_controller_1/fifo_data_o]
  connect_bd_net -net stream_controller_1_st_flag_o [get_bd_pins serdes_lvds_1/st_flag_i] [get_bd_pins stream_controller_1/st_flag_o]
  connect_bd_net -net stream_controller_1_start_o [get_bd_pins serdes_lvds_1/start_i] [get_bd_pins stream_controller_1/start_o]
  connect_bd_net -net stream_master_0_m_axis_tdata [get_bd_pins fifo_serdes_0/data_i] [get_bd_pins stream_master_0/m_axis_tdata]
  connect_bd_net -net stream_master_0_m_axis_tvalid [get_bd_pins fifo_serdes_0/tvalid_i] [get_bd_pins fifo_serdes_0/wr_en_slow] [get_bd_pins stream_master_0/m_axis_tvalid]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port clk -pg 1 -y -150 -defaultsOSRD
preplace inst stream_controller_0 -pg 1 -lvl 4 -y -120 -defaultsOSRD
preplace inst stream_controller_1 -pg 1 -lvl 7 -y -150 -defaultsOSRD
preplace inst fifo_serdes_0 -pg 1 -lvl 3 -y -170 -defaultsOSRD
preplace inst fifo_serdes_1 -pg 1 -lvl 8 -y -180 -defaultsOSRD
preplace inst stream_slave_1 -pg 1 -lvl 9 -y -180 -defaultsOSRD
preplace inst clk_gen_0 -pg 1 -lvl 1 -y -150 -defaultsOSRD
preplace inst serdes_lvds_0 -pg 1 -lvl 5 -y -180 -defaultsOSRD
preplace inst stream_master_0 -pg 1 -lvl 2 -y -160 -defaultsOSRD
preplace inst serdes_lvds_1 -pg 1 -lvl 6 -y -180 -defaultsOSRD
preplace netloc fifo_serdes_1_fifo_empty_ctrl 1 6 3 1760 20 NJ 20 2400
preplace netloc fifo_serdes_1_fifo_full 1 6 3 1740 -330 NJ -330 2400
preplace netloc fifo_serdes_0_ready_stream 1 2 2 NJ -30 710
preplace netloc serdes_lvds_1_lvds_busy 1 6 1 1720
preplace netloc serdes_lvds_0_data_o 1 3 3 800 40 NJ 40 1400
preplace netloc stream_master_0_m_axis_tdata 1 2 1 380
preplace netloc fifo_serdes_0_fifo_full_ctrl 1 3 1 740
preplace netloc fifo_serdes_0_data_o 1 3 1 760
preplace netloc serdes_lvds_0_serial_o 1 5 1 1420
preplace netloc serdes_lvds_1_data_o 1 6 1 1700
preplace netloc stream_controller_1_data_o 1 5 3 1430 -10 NJ -10 2070
preplace netloc clk_gen_0_clk_serdes 1 1 8 60 -250 390 -310 770 -280 1110 -280 1420 -280 NJ -290 NJ -320 NJ
preplace netloc stream_controller_0_data_o 1 4 1 1130
preplace netloc stream_controller_0_fifo_command_o 1 2 3 410 20 NJ 20 1110
preplace netloc fifo_serdes_1_fifo_empty_axi 1 6 3 1750 10 NJ 10 2410
preplace netloc stream_controller_1_m_axis_tdata 1 7 1 N
preplace netloc serdes_lvds_0_st_flag_o 1 3 3 750 50 NJ 50 1410
preplace netloc stream_controller_0_st_flag 1 4 1 1140
preplace netloc stream_controller_1_fifo_wren_o 1 7 1 2090
preplace netloc serdes_lvds_1_st_flag_o 1 6 1 1730
preplace netloc stream_controller_0_start_o 1 4 1 1120
preplace netloc stream_master_0_m_axis_tvalid 1 2 1 390
preplace netloc serdes_lvds_0_lvds_busy 1 3 3 790 -300 NJ -300 1410
preplace netloc serdes_lvds_1_serial_o 1 4 3 1140 -270 NJ -270 1700
preplace netloc clk_1 1 0 1 N
preplace netloc fifo_serdes_0_fifo_full_axi 1 3 1 750
preplace netloc stream_controller_1_start_o 1 5 3 1430 -300 NJ -300 2080
preplace netloc stream_controller_1_st_flag_o 1 5 3 1440 0 NJ 0 2060
preplace netloc stream_controller_1_fifo_command_o 1 7 1 2100
preplace netloc fifo_serdes_0_fifo_empty_axi 1 3 1 730
preplace netloc stream_controller_0_s_axi_tready 1 2 3 400 30 NJ 30 1100
preplace netloc clk_gen_0_res 1 1 6 NJ -330 NJ -330 NJ -310 NJ -310 NJ -310 NJ
preplace netloc fifo_serdes_1_fifo_full_axi 1 6 3 1730 -340 NJ -340 2410
preplace netloc fifo_serdes_0_fifo_empty 1 3 1 720
preplace netloc clk_gen_0_res_n 1 1 8 NJ -240 NJ -350 NJ -350 NJ -350 NJ -350 NJ -350 NJ -350 NJ
levelinfo -pg 1 -340 -50 230 560 950 1270 1570 1910 2250 2530 2640 -top -450 -bot 80
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


