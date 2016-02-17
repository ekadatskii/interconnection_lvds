
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

  # Create instance: axi_full_master_0, and set properties
  set axi_full_master_0 [ create_bd_cell -type ip -vlnv user.org:user:axi_full_master:1.0 axi_full_master_0 ]

  # Create instance: axi_full_slave_0, and set properties
  set axi_full_slave_0 [ create_bd_cell -type ip -vlnv user.org:user:axi_full_slave:1.0 axi_full_slave_0 ]

  # Create instance: clk_gen_0, and set properties
  set clk_gen_0 [ create_bd_cell -type ip -vlnv user.org:user:clk_gen:1.0 clk_gen_0 ]

  # Create instance: parallella_lvds_controller_0, and set properties
  set parallella_lvds_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:parallella_lvds_controller:1.0 parallella_lvds_controller_0 ]

  # Create instance: parsboard_lvds_controller_0, and set properties
  set parsboard_lvds_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:parsboard_lvds_controller:1.0 parsboard_lvds_controller_0 ]

  # Create instance: serdes_lvds_0, and set properties
  set serdes_lvds_0 [ create_bd_cell -type ip -vlnv user.org:user:serdes_lvds:1.0 serdes_lvds_0 ]

  # Create instance: serdes_lvds_1, and set properties
  set serdes_lvds_1 [ create_bd_cell -type ip -vlnv user.org:user:serdes_lvds:1.0 serdes_lvds_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_full_master_0_M00_AXI [get_bd_intf_pins axi_full_master_0/M00_AXI] [get_bd_intf_pins parsboard_lvds_controller_0/S00_AXI]
  connect_bd_intf_net -intf_net parallella_lvds_controller_0_M00_AXI [get_bd_intf_pins axi_full_slave_0/S00_AXI] [get_bd_intf_pins parallella_lvds_controller_0/M00_AXI]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins clk_gen_0/clk]
  connect_bd_net -net num_gen_0_clk_ms [get_bd_pins axi_full_master_0/m00_axi_aclk] [get_bd_pins axi_full_slave_0/s00_axi_aclk] [get_bd_pins clk_gen_0/clk_ms] [get_bd_pins parallella_lvds_controller_0/clk] [get_bd_pins parsboard_lvds_controller_0/clk] [get_bd_pins serdes_lvds_0/clk] [get_bd_pins serdes_lvds_1/clk]
  connect_bd_net -net num_gen_0_res [get_bd_pins clk_gen_0/res] [get_bd_pins parallella_lvds_controller_0/reset] [get_bd_pins parsboard_lvds_controller_0/reset]
  connect_bd_net -net num_gen_0_res_n [get_bd_pins axi_full_master_0/m00_axi_aresetn] [get_bd_pins axi_full_slave_0/s00_axi_aresetn] [get_bd_pins clk_gen_0/res_n]
  connect_bd_net -net parallella_lvds_controller_0_command_o [get_bd_pins parallella_lvds_controller_0/command_o] [get_bd_pins serdes_lvds_0/command_i]
  connect_bd_net -net parallella_lvds_controller_0_data_o [get_bd_pins parallella_lvds_controller_0/data_o] [get_bd_pins serdes_lvds_0/data_i]
  connect_bd_net -net parallella_lvds_controller_0_start_o [get_bd_pins parallella_lvds_controller_0/start_o] [get_bd_pins serdes_lvds_0/start_i]
  connect_bd_net -net parsboard_lvds_controller_0_command_o [get_bd_pins parsboard_lvds_controller_0/command_o] [get_bd_pins serdes_lvds_1/command_i]
  connect_bd_net -net parsboard_lvds_controller_0_data_o [get_bd_pins parsboard_lvds_controller_0/data_o] [get_bd_pins serdes_lvds_1/data_i]
  connect_bd_net -net parsboard_lvds_controller_0_start_o [get_bd_pins parsboard_lvds_controller_0/start_o] [get_bd_pins serdes_lvds_1/start_i]
  connect_bd_net -net serdes_lvds_0_data_o [get_bd_pins parallella_lvds_controller_0/data_i] [get_bd_pins serdes_lvds_0/data_o]
  connect_bd_net -net serdes_lvds_0_lvds_busy [get_bd_pins parallella_lvds_controller_0/lvds_busy] [get_bd_pins serdes_lvds_0/lvds_busy]
  connect_bd_net -net serdes_lvds_0_serial_o [get_bd_pins serdes_lvds_0/serial_o] [get_bd_pins serdes_lvds_1/serial_i]
  connect_bd_net -net serdes_lvds_1_data_o [get_bd_pins parsboard_lvds_controller_0/data_i] [get_bd_pins serdes_lvds_1/data_o]
  connect_bd_net -net serdes_lvds_1_lvds_busy [get_bd_pins parsboard_lvds_controller_0/lvds_busy] [get_bd_pins serdes_lvds_1/lvds_busy]
  connect_bd_net -net serdes_lvds_1_serial_o [get_bd_pins serdes_lvds_0/serial_i] [get_bd_pins serdes_lvds_1/serial_o]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port clk -pg 1 -y 50 -defaultsOSRD
preplace inst axi_full_slave_0 -pg 1 -lvl 2 -y 10 -defaultsOSRD
preplace inst parsboard_lvds_controller_0 -pg 1 -lvl 6 -y 10 -defaultsOSRD
preplace inst clk_gen_0 -pg 1 -lvl 1 -y 50 -defaultsOSRD
preplace inst serdes_lvds_0 -pg 1 -lvl 4 -y 10 -defaultsOSRD
preplace inst serdes_lvds_1 -pg 1 -lvl 5 -y 10 -defaultsOSRD
preplace inst axi_full_master_0 -pg 1 -lvl 7 -y 10 -defaultsOSRD
preplace inst parallella_lvds_controller_0 -pg 1 -lvl 3 -y 10 -defaultsOSRD
preplace netloc serdes_lvds_1_lvds_busy 1 5 1 1510
preplace netloc serdes_lvds_0_data_o 1 2 3 600 130 NJ 130 1190
preplace netloc num_gen_0_clk_ms 1 1 6 190 -60 590 -80 900 -80 1210 -80 1530 100 NJ
preplace netloc parallella_lvds_controller_0_data_o 1 3 1 900
preplace netloc num_gen_0_res_n 1 1 6 190 110 NJ 110 NJ 110 NJ 110 NJ 110 NJ
preplace netloc serdes_lvds_1_data_o 1 5 1 N
preplace netloc parsboard_lvds_controller_0_start_o 1 4 3 1220 150 NJ 150 1820
preplace netloc parsboard_lvds_controller_0_command_o 1 4 3 1230 120 NJ 120 1810
preplace netloc serdes_lvds_0_serial_o 1 4 1 1210
preplace netloc parsboard_lvds_controller_0_data_o 1 4 3 1240 130 NJ 130 1800
preplace netloc parallella_lvds_controller_0_M00_AXI 1 1 3 NJ -70 NJ -70 890
preplace netloc clk_1 1 0 1 N
preplace netloc serdes_lvds_0_lvds_busy 1 2 3 610 120 NJ 120 1200
preplace netloc parallella_lvds_controller_0_command_o 1 3 1 890
preplace netloc serdes_lvds_1_serial_o 1 3 3 NJ 140 NJ 140 1500
preplace netloc axi_full_master_0_M00_AXI 1 5 3 1540 -80 NJ -80 2150
preplace netloc num_gen_0_res 1 1 5 200 80 NJ 100 NJ 100 NJ 100 1520
preplace netloc parallella_lvds_controller_0_start_o 1 3 1 900
levelinfo -pg 1 -30 90 500 760 1060 1370 1670 2000 2180 -top -270 -bot 240
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


puts "\n\nWARNING: This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

