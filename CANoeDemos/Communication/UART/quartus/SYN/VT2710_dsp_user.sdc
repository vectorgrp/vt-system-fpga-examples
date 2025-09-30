
create_clock -period "12 MHz" -name {pi_fpga_clock0} {pi_fpga_clock[0]}
create_clock -period "12 MHz" -name {pi_fpga_clock1} {pi_fpga_clock[1]}
create_clock -period "96 MHz" -name {pi_f2b_rx_clk} {pi_f2b_rx_clk}

if [get_collection_size [get_registers *ibc_top*ibc_itf_rx*.sr[7]]] {
    create_clock -period "80 MHz" -name ibc_clock_rx {pi_mic_lvds[0]}
}

create_clock -period "96 MHz" -name dsp_io_datain_clk -waveform {7.812 13.021}

derive_pll_clocks 
derive_clock_uncertainty

create_generated_clock -source [get_pins {inst_ftpll|altpll_component|auto_generated|pll1|clk[0]}] -name dsp_io_out_clk [get_ports {po_f2b_tx_clk}]


set_clock_groups -exclusive  -group {pi_fpga_clock0} \
                             -group {pi_fpga_clock1} \
			     -group {pi_f2b_rx_clk dsp_io_datain_clk} \
			     -group {ibc_clock_rx} \
			     -group {inst_frpll|altpll_component|auto_generated|pll1|clk[0]} \
			     -group {inst_ftpll|altpll_component|auto_generated|pll1|clk[0] inst_ftpll|altpll_component|auto_generated|pll1|clk[1] inst_ftpll|altpll_component|auto_generated|pll1|clk[2] dsp_io_out_clk} \
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




set_output_delay -clock dsp_io_out_clk -min [expr -1.4]             [get_ports {pio_f2b_device_specific[0] pio_f2b_device_specific[1] pio_f2b_device_specific[3] pio_f2b_device_specific[5] pio_f2b_device_specific[6] pio_f2b_device_specific[7] pio_f2b_device_specific[8] pio_f2b_device_specific[9] pio_f2b_device_specific[10] pio_f2b_device_specific[12] pio_f2b_device_specific[15] pio_f2b_device_specific[20] pio_f2b_device_specific[25] pio_f2b_device_specific[29] pio_f2b_device_specific[32]}]
set_output_delay -clock dsp_io_out_clk -max [expr 1.4]		    [get_ports {pio_f2b_device_specific[0] pio_f2b_device_specific[1] pio_f2b_device_specific[3] pio_f2b_device_specific[5] pio_f2b_device_specific[6] pio_f2b_device_specific[7] pio_f2b_device_specific[8] pio_f2b_device_specific[9] pio_f2b_device_specific[10] pio_f2b_device_specific[12] pio_f2b_device_specific[15] pio_f2b_device_specific[20] pio_f2b_device_specific[25] pio_f2b_device_specific[29] pio_f2b_device_specific[32]}]
set_output_delay -clock dsp_io_out_clk -clock_fall -min [expr -1.4] [get_ports {pio_f2b_device_specific[0] pio_f2b_device_specific[1] pio_f2b_device_specific[3] pio_f2b_device_specific[5] pio_f2b_device_specific[6] pio_f2b_device_specific[7] pio_f2b_device_specific[8] pio_f2b_device_specific[9] pio_f2b_device_specific[10] pio_f2b_device_specific[12] pio_f2b_device_specific[15] pio_f2b_device_specific[20] pio_f2b_device_specific[25] pio_f2b_device_specific[29] pio_f2b_device_specific[32]}] -add_delay
set_output_delay -clock dsp_io_out_clk -clock_fall -max [expr 1.4]  [get_ports {pio_f2b_device_specific[0] pio_f2b_device_specific[1] pio_f2b_device_specific[3] pio_f2b_device_specific[5] pio_f2b_device_specific[6] pio_f2b_device_specific[7] pio_f2b_device_specific[8] pio_f2b_device_specific[9] pio_f2b_device_specific[10] pio_f2b_device_specific[12] pio_f2b_device_specific[15] pio_f2b_device_specific[20] pio_f2b_device_specific[25] pio_f2b_device_specific[29] pio_f2b_device_specific[32]}] -add_delay

set_false_path -setup -rise_from [get_clocks inst_ftpll|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks dsp_io_out_clk]
set_false_path -setup -fall_from [get_clocks inst_ftpll|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks dsp_io_out_clk]
set_false_path -hold  -rise_from [get_clocks inst_ftpll|altpll_component|auto_generated|pll1|clk[2]] -rise_to [get_clocks dsp_io_out_clk]
set_false_path -hold  -fall_from [get_clocks inst_ftpll|altpll_component|auto_generated|pll1|clk[2]] -fall_to [get_clocks dsp_io_out_clk]


 
set_input_delay -clock [get_clocks dsp_io_datain_clk] -min [expr -1.3]             [get_ports {pio_f2b_device_specific[4] pio_f2b_device_specific[13] pio_f2b_device_specific[17] pio_f2b_device_specific[18] pio_f2b_device_specific[22] pio_f2b_device_specific[23] pio_f2b_device_specific[24] pio_f2b_device_specific[28] pio_f2b_device_specific[30] pio_f2b_device_specific[31] pio_f2b_device_specific[33] pio_f2b_device_specific[34] pio_f2b_device_specific[35] pio_f2b_device_specific[36] pio_f2b_device_specific[37]}]
set_input_delay -clock [get_clocks dsp_io_datain_clk] -max [expr 1.3]              [get_ports {pio_f2b_device_specific[4] pio_f2b_device_specific[13] pio_f2b_device_specific[17] pio_f2b_device_specific[18] pio_f2b_device_specific[22] pio_f2b_device_specific[23] pio_f2b_device_specific[24] pio_f2b_device_specific[28] pio_f2b_device_specific[30] pio_f2b_device_specific[31] pio_f2b_device_specific[33] pio_f2b_device_specific[34] pio_f2b_device_specific[35] pio_f2b_device_specific[36] pio_f2b_device_specific[37]}]
set_input_delay -clock [get_clocks dsp_io_datain_clk] -clock_fall -min [expr -1.3] [get_ports {pio_f2b_device_specific[4] pio_f2b_device_specific[13] pio_f2b_device_specific[17] pio_f2b_device_specific[18] pio_f2b_device_specific[22] pio_f2b_device_specific[23] pio_f2b_device_specific[24] pio_f2b_device_specific[28] pio_f2b_device_specific[30] pio_f2b_device_specific[31] pio_f2b_device_specific[33] pio_f2b_device_specific[34] pio_f2b_device_specific[35] pio_f2b_device_specific[36] pio_f2b_device_specific[37]}] -add_delay
set_input_delay -clock [get_clocks dsp_io_datain_clk] -clock_fall -max [expr 1.3]  [get_ports {pio_f2b_device_specific[4] pio_f2b_device_specific[13] pio_f2b_device_specific[17] pio_f2b_device_specific[18] pio_f2b_device_specific[22] pio_f2b_device_specific[23] pio_f2b_device_specific[24] pio_f2b_device_specific[28] pio_f2b_device_specific[30] pio_f2b_device_specific[31] pio_f2b_device_specific[33] pio_f2b_device_specific[34] pio_f2b_device_specific[35] pio_f2b_device_specific[36] pio_f2b_device_specific[37]}] -add_delay

set_false_path -setup -fall_from [get_clocks dsp_io_datain_clk] -rise_to [get_clocks pi_f2b_rx_clk]
set_false_path -setup -rise_from [get_clocks dsp_io_datain_clk] -fall_to [get_clocks pi_f2b_rx_clk]
set_false_path -hold  -rise_from [get_clocks dsp_io_datain_clk] -rise_to [get_clocks pi_f2b_rx_clk]
set_false_path -hold  -fall_from [get_clocks dsp_io_datain_clk] -fall_to [get_clocks pi_f2b_rx_clk]



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
