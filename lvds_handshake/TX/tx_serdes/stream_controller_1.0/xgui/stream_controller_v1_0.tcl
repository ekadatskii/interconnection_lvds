# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "LVDS_PIN_NUMBER"

}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.LVDS_PIN_NUMBER { PARAM_VALUE.LVDS_PIN_NUMBER } {
	# Procedure called to update LVDS_PIN_NUMBER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LVDS_PIN_NUMBER { PARAM_VALUE.LVDS_PIN_NUMBER } {
	# Procedure called to validate LVDS_PIN_NUMBER
	return true
}


proc update_MODELPARAM_VALUE.LVDS_PIN_NUMBER { MODELPARAM_VALUE.LVDS_PIN_NUMBER PARAM_VALUE.LVDS_PIN_NUMBER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LVDS_PIN_NUMBER}] ${MODELPARAM_VALUE.LVDS_PIN_NUMBER}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

