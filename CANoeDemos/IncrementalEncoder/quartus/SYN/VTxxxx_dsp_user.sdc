
create_clock -period "12 MHz" -name {pi_fpga_clock0} {pi_fpga_clock[0]}
create_clock -period "12 MHz" -name {pi_fpga_clock1} {pi_fpga_clock[1]}
create_clock -period "96 MHz" -name {pi_f2b_rx_clk} {pi_f2b_rx_clk}

if [get_collection_size [get_registers *ibc_top*ibc_itf_rx*.sr[7]]] {
    create_clock -period "80 MHz" -name ibc_clock_rx {pi_mic_lvds[0]}
}

derive_pll_clocks 
derive_clock_uncertainty

set_clock_groups -exclusive  -group {pi_fpga_clock0} \
                             -group {pi_fpga_clock1} \
			     -group {pi_f2b_rx_clk} \
			     -group {ibc_clock_rx} \
			     -group {inst_frpll|altpll_component|auto_generated|pll1|clk[0]} \
			     -group {inst_ftpll|altpll_component|auto_generated|pll1|clk[0] inst_ftpll|altpll_component|auto_generated|pll1|clk[1]} \
			     -group {inst_wpll|altpll_component|auto_generated|pll1|clk[0]} \
			     -group {inst_wpll|altpll_component|auto_generated|pll1|clk[1]} \
			     -group {inst_wpll|altpll_component|auto_generated|pll1|clk[2]}

#=============================================================================================================================================
#= FPGA Bridge == ============================================================================================================================
#=============================================================================================================================================
set f2b_clock 	     inst_ftpll|altpll_component|auto_generated|pll1|clk[1]
set f2b_clock_shift  inst_ftpll|altpll_component|auto_generated|pll1|clk[0]
set f2b_rx_clock     inst_frpll|altpll_component|auto_generated|pll1|clk[0]

set_output_delay -clock $f2b_clock_shift -reference_pin [get_ports po_f2b_tx_clk] -min [expr -2.5] [get_ports {po_f2b_tx_e*}]
set_output_delay -clock $f2b_clock_shift -reference_pin [get_ports po_f2b_tx_clk] -max [expr 2.5] [get_ports {po_f2b_tx_e*}]
set_output_delay -clock $f2b_clock_shift -reference_pin [get_ports po_f2b_tx_clk] -min [expr -2.5] [get_ports {po_f2b_tx_d*}]
set_output_delay -clock $f2b_clock_shift -reference_pin [get_ports po_f2b_tx_clk] -max [expr 2.5] [get_ports {po_f2b_tx_d*}]

#set_multicycle_path -setup -end -from $f2b_clock -to $f2b_clock_shift 2
#set_multicycle_path -hold -end -from $f2b_clock -to $f2b_clock_shift 0

set_input_delay	 -clock $f2b_rx_clock -min [expr 1.0] [get_ports {pi_f2b_rx_e*}]
set_input_delay	 -clock $f2b_rx_clock -max [expr 9.4] [get_ports {pi_f2b_rx_e*}]
set_input_delay	 -clock $f2b_rx_clock -min [expr 1.0] [get_ports {pi_f2b_rx_d*}]
set_input_delay	 -clock $f2b_rx_clock -max [expr 9.4] [get_ports {pi_f2b_rx_d*}]

set_max_delay -from [get_ports {pi_f2b_reset}] -to * 7
set_min_delay -from [get_ports {pi_f2b_reset}] -to * 0

set_max_delay -from [get_ports {pi_f2b_data_req}] -to * 7
set_min_delay -from [get_ports {pi_f2b_data_req}] -to * 0

set_max_delay -from * -to [get_ports {po_f2b_nlocked}] 7
set_min_delay -from * -to [get_ports {po_f2b_nlocked}] 0

#=============================================================================================================================================
#= Device Specific Pins == ===================================================================================================================
#=============================================================================================================================================
set_max_delay -from * -to [get_ports {pio_f2b_device_specific*}] 10
set_min_delay -from * -to [get_ports {pio_f2b_device_specific*}] 0

set_max_delay -from [get_ports {pio_f2b_device_specific*}] -to * 10
set_min_delay -from [get_ports {pio_f2b_device_specific*}] -to * 0

#=============================================================================================================================================
#= Module Interconnect == ====================================================================================================================
#=============================================================================================================================================
set_max_delay -from * -to [get_ports {po_mic_lvds*}] 10
set_min_delay -from * -to [get_ports {po_mic_lvds*}] 0

if [get_collection_size [get_registers *ibc_top*ibc_itf_rx*.sr[7]]] {
    set_input_delay -clock ibc_clock_rx -clock_fall -max 6 {pi_mic_lvds[1]}
    set_input_delay -clock ibc_clock_rx -clock_fall -min 0.5 {pi_mic_lvds[1]}
} {
    set_max_delay -from [get_ports {pi_mic_lvds[0]}] -to * 10
    set_min_delay -from [get_ports {pi_mic_lvds[0]}] -to * 0
    set_max_delay -from [get_ports {pi_mic_lvds[1]}] -to * 10
    set_min_delay -from [get_ports {pi_mic_lvds[1]}] -to * 0
}

set_max_delay -from [get_ports {pi_mic_lvds[2]}] -to * 10
set_min_delay -from [get_ports {pi_mic_lvds[2]}] -to * 0
set_max_delay -from [get_ports {pi_mic_lvds[3]}] -to * 10
set_min_delay -from [get_ports {pi_mic_lvds[3]}] -to * 0



#=============================================================================================================================================
#= Debug LED == ==============================================================================================================================
#=============================================================================================================================================
set_max_delay -from * -to [get_ports {po_debug_led*}] 15
set_min_delay -from * -to [get_ports {po_debug_led*}] 0
