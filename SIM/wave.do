onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /ram_tb_top/intf/clk
add wave -noupdate -radix unsigned /ram_tb_top/intf/rst
add wave -noupdate -radix unsigned /ram_tb_top/intf/we
add wave -noupdate -radix unsigned /ram_tb_top/intf/waddr
add wave -noupdate -radix unsigned /ram_tb_top/intf/wdata
add wave -noupdate -radix unsigned /ram_tb_top/intf/re
add wave -noupdate -radix unsigned /ram_tb_top/intf/raddr
add wave -noupdate -radix unsigned /ram_tb_top/intf/rdata
add wave -noupdate -radix unsigned /ram_tb_top/intf/exp_rdata
add wave -noupdate -radix unsigned /ram_tb_top/intf/drv_cb/drv_cb_event
add wave -noupdate -radix unsigned /ram_tb_top/intf/mon_cb/mon_cb_event
add wave -noupdate -radix unsigned /ram_pkg::reset_start_ev
add wave -noupdate -radix unsigned /ram_pkg::reset_done_ev
add wave -noupdate -radix unsigned /ram_pkg::drv_done
add wave -noupdate -radix unsigned /ram_pkg::raise_ctr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9034 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {8994 ns} {9078 ns}
