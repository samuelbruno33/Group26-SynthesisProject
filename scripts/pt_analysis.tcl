##	+----------------------------------------------------------------
##	|		 Synthesis and Optimization of Digital Systems			|
##	|				Politecnico di Torino - TO - Italy				|
##	|						DAUIN - EDA GROUP						|
##	+----------------------------------------------------------------
##	|	author: Valentino Peluso									|
##	|	mail:	valentino.peluso@polito.it							|
##	|	title:	pt_analysis.tcl										|
##	+----------------------------------------------------------------
##	| 	Copyright 2026 DAUIN - EDA GROUP							|
##	+----------------------------------------------------------------

######################################################################
##
## SPECIFY LIBRARIES
##
######################################################################

# SOURCE SETUP FILE
source "./synopsys_pt.setup"

# DEFINE OPTIONS
set report_default_significant_digits 6
set power_enable_analysis true

# SUPPRESS WARNING MESSAGES
suppress_message RC-004
suppress_message PTE-003
suppress_message UID-401
suppress_message ENV-003
suppress_message UITE-489
suppress_message CMD-041
suppress_message PLIB-166
suppress_message PLIB-167
suppress_message PTE-139
suppress_message NED-045

######################################################################
##
## READ DESIGN
##
######################################################################
# DEFINE CIRCUITS
set blockName "sha1_core"

# DEFINE INPUT FILES
set dir "./saved/${blockName}/synthesis"
set in_verilog_filename "${dir}/${blockName}_postsyn.v"
set in_sdc_filename "${dir}/${blockName}_postsyn.sdc"

# READ
read_verilog $in_verilog_filename
link_design $blockName
read_sdc $in_sdc_filename
set_ideal_network "clk"
set_ideal_network "rst_n"

update_timing -full

######################################################################
##
## TIMING ANALYSIS
##
######################################################################
# SETUP TIME
report_timing -delay_type max

# SLACK CONDITION
report_timing -delay_type min -slack_lesser_than 0.1 -max_paths 2
report_timing -delay_type max -slack_lesser_than 0.0 -max_paths 2

######################################################################
##
## POWER ANALYSIS (VCD-BASED SWA BACK-ANNOTATION)
##
######################################################################
# IMPORTANT: Adjust the path to the VCD file and the strip_path based on your testbench names
set vcd_file "./saved/${blockName}/simulation/${blockName}.vcd"
read_vcd $vcd_file -strip_path "/testbench_name/dut_instance" -zero_delay

set_power_clock_scaling -period [get_attribute [get_clocks] period] [get_clocks]
set power_enable_clock_scaling true

update_power
report_power

######################################################################
##
## EXTRACT AND REPORT METRICS (Custom section for Ex 1)
##
######################################################################
set clockPeriod [get_attribute [get_clocks] period]
set wrt_slack [get_attribute [get_timing_paths] slack]
set area [get_attribute [current_design] area]
set dynamic [get_attribute [current_design] dynamic_power]
set leakage [get_attribute [current_design] leakage_power]

puts "\n========================================================"
puts "                EXERCISE 1 - METRICS REPORT"
puts "========================================================"
puts "Clock period (ns) : $clockPeriod"
puts "Area (um2)        : $area"
puts "Slack (ns)        : $wrt_slack"
puts "Leakage power (mW): $leakage"
puts "Dynamic power (mW): $dynamic"
puts "========================================================\n"

######################################################################
##
## EXIT
##
######################################################################
exit