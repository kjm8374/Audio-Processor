vlib work
vmap altera_mf ../../src/altera_mf
vcom -93 -work work ../../src/rom_data/rom_data.vhd
vcom -93 -work work ../../src/rom_instructions/rom_instructions.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/dj_roomba_3000.vhd
vcom -93 -work work ../../src/next_state_logic_rom.vhd
vcom -93 -work work ../src/dj_roomba_3000_tb.vhd
vsim -voptargs=+acc dj_roomba_3000_tb
do wave.do
run 20000 us