onerror {resume}
radix define States {
    "8'b000?????" "Play" -color "green",
    "8'b001?????" "Play Repeat" -color "purple",
    "8'b01??????" "Pause" -color "orange",
    "8'b10??????" "Seek" -color "blue",
    "8'b11??????" "Stop" -color "red",
    -default hexadecimal
    -defaultcolor white
}
radix define Instructions {
    "8'b0001000000" "Play 0" -color "green",
    "8'b0010000000" "Play 1" -color "green",
    "8'b0001100000" "Play 0 Repeat" -color "purple",
    "8'b0010100000" "Play 1 Repeat" -color "purple",
    "8'b0011100000" "Play 0/1 Repeat" -color "purple",
    "8'b0100000000" "Pause" -color "orange",
    "8'b1011001000" "Seek 0/1" -color "blue",
    "8'b1011001000" "Seek 0" -color "blue",
    "8'b1010001000" "Seek 1" -color "blue",
    "8'b1100000000" "Stop" -color "red",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dj_roomba_3000_tb/clk
add wave -noupdate /dj_roomba_3000_tb/reset
add wave -noupdate /dj_roomba_3000_tb/sync
add wave -noupdate /dj_roomba_3000_tb/execute_btn
add wave -noupdate -expand -group uut /dj_roomba_3000_tb/dj_roomba/sync
add wave -noupdate -expand -group uut /dj_roomba_3000_tb/dj_roomba/reset
add wave -noupdate -expand -group uut /dj_roomba_3000_tb/dj_roomba/led
add wave -noupdate -expand -group uut /dj_roomba_3000_tb/dj_roomba/execute_btn
add wave -noupdate -expand -group {New Group} -format Analog-Step -height 74 -max 1492.0 /dj_roomba_3000_tb/dj_roomba/audio_out
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/ch0_audio
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/ch1_audio
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/data_address_ch1
add wave -noupdate /dj_roomba_3000_tb/dj_roomba/data_address_ch0
add wave -noupdate -radix Instructions /dj_roomba_3000_tb/dj_roomba/q_instruc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19997978 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
configure wave -valuecolwidth 180
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {19924912 ns} {20003952 ns}
