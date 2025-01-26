G90 ; use absolute coordinates
M83 ; extruder relative mode
M204 S[machine_max_acceleration_extruding] T[machine_max_acceleration_retracting]
M104 S[nozzle_temperature_initial_layer] ; set extruder temp
M140 S[bed_temperature_initial_layer_single] ; set bed temp
G28 ; home all
; hb begin instructions to use the mesh
M501 ; hb load all saved settings from eeprom
M420 S1 ; hb switch bed levelling on
G29 S4 Z-0.12
; hb end instructions to use the mesh
G1 Y1.0 Z0.3 F1000 ; move print head up
M190 S[bed_temperature_initial_layer_single] ; wait for bed temp
M109 S[nozzle_temperature_initial_layer] ; wait for extruder temp
G92 E0.0
; initial load
G1 X205.0 E19 F1000
G1 Y1.6
G1 X5.0 E19 F1000
G92 E0.0
; intro line
G1 Y2.0 Z0.2 F1000
G1 X65.0 E9.0 F1000
G1 X105.0 E12.5 F1000
G92 E0.0