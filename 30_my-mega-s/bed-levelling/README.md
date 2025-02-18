# Bed Levelling

## 1. Manual Mesh

- Via Marlin LCD Menu
  - <https://www.youtube.com/shorts/1-UEWbcggMo>
  - <https://www.youtube.com/watch?v=B_rkGoc3aTE&ab_channel=iTryTec>
  - [Compile Marlin](https://forum.drucktipps3d.de/forum/thread/10998-anleitung-marlin-konfigurieren-g29-bed-leveling-ohne-sensor/)

## 2. Create Mesh with gcodes

- <https://marlinfw.org/docs/gcode/G029-mbl.html>

```gcode
Mesh Bed Leveling from the host:

Use G29 S0 to get the current status and mesh. If there’s an existing mesh, you can send M420 S1 to use it.
Use G29 S1 to move to the first point for Z adjustment.
Adjust Z so a piece of paper can just pass under the nozzle.
Use G29 S2 to save the Z value and move to the next point.
Repeat steps 3-4 until completed.
Use M500 to save the mesh to EEPROM, if desired.
```

### 2.1. Start gcode

The following is insereted into `Bambu Studio / Printer settings / Machine start G-code` directly __after__ `G28`

```gcode
; hb begin instructions to use the mesh
M501 ; hb load all saved settings from eeprom
M420 S1 ; hb switch bed levelling on
G29 S4 Z-0.08 ; Value changed at 2025-02-10
; hb end instructions to use the mesh
```

### 2.2. Mesh from third calibration on 2025-02-18 13:19:22

Durchgeführt mit Folie vom doppelseitigen transparenten Klebeband. 
Die Folie hat gemessene Dicke von 0,04mm.

```gcode
[...]
Send: G29 S0
Recv: Mesh Bed Leveling ON
Recv: 5x5 mesh. Z offset: 0.00000
Recv: Measured points:
Recv:         0        1        2        3        4
Recv:  0 -0.39000 -0.31000 -0.33000 -0.42000 -0.60000
Recv:  1 -0.26000 -0.17000 -0.21000 -0.27000 -0.42000
Recv:  2 -0.24000 -0.15000 -0.17000 -0.24000 -0.39000
Recv:  3 -0.24000 -0.18000 -0.23000 -0.31000 -0.47000
Recv:  4 -0.25000 -0.22000 -0.28000 -0.39000 -0.60000
Recv: 
Recv: X:2.00 Y:2.00 Z:20.42 E:-34.00 Count X:160 Y:160 Z:8000
Recv: ok
```

Mit Start Code `G29 S4 Z-0.0`, or in full:

```gcode
G90 ; use absolute coordinates
M83 ; extruder relative mode
M204 S[machine_max_acceleration_extruding] T[machine_max_acceleration_retracting]
M104 S[nozzle_temperature_initial_layer] ; set extruder temp
M140 S[bed_temperature_initial_layer_single] ; set bed temp
G28 ; home all
; hb begin instructions to use the mesh
M501 ; hb load all saved settings from eeprom
M420 S1 ; hb switch bed levelling on
; hb mesh 2025-02-08: G29 S4 Z-0.08
G29 S4 Z-0.0
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
```

### 2.3. Mesh from second calibration on 2025-02-08

```gcode
Send: G29 S0
Recv: Mesh Bed Leveling OFF
Recv: 5x5 mesh. Z offset: 0.00000
Recv: Measured points:
Recv:         0        1        2        3        4
Recv:  0 -0.20000 -0.18000 -0.23000 -0.30000 -0.39000
Recv:  1 -0.13000 -0.07000 -0.09000 -0.12000 -0.21000
Recv:  2 -0.14000 -0.07000 -0.06000 -0.11000 -0.20000
Recv:  3 -0.12000 -0.07000 -0.11000 -0.16000 -0.27000
Recv:  4 -0.09000 -0.08000 -0.14000 -0.23000 +0.00000
Recv:
Recv: X:0.00 Y:0.00 Z:0.00 E:0.00 Count X:0 Y:0 Z:0
Recv: ok
Recv:  T:43.79 /0.00 B:38.33 /0.00 @:0 B@:0
Recv:  T:43.68 /0.00 B:38.33 /0.00 @:0 B@:0
```

Looks like i forgot the last mesh point.
Let's try to set it manually

```gcode
G29 S3 I4 J4 Z-0.33
M500 ; Save to EEPROM
```

Now the mesh is

```gcode
Send: G29 S0
Recv: Mesh Bed Leveling OFF
Recv: 5x5 mesh. Z offset: 0.00000
Recv: Measured points:
Recv:         0        1        2        3        4
Recv:  0 -0.20000 -0.18000 -0.23000 -0.30000 -0.39000
Recv:  1 -0.13000 -0.07000 -0.09000 -0.12000 -0.21000
Recv:  2 -0.14000 -0.07000 -0.06000 -0.11000 -0.20000
Recv:  3 -0.12000 -0.07000 -0.11000 -0.16000 -0.27000
Recv:  4 -0.09000 -0.08000 -0.14000 -0.23000 -0.33000
Recv:
Recv: X:0.00 Y:0.00 Z:0.00 E:0.00 Count X:0 Y:0 Z:0
Recv: ok
```

With `G29 S4 Z-0.06` the print warped so I changed to

```gcode
G29 S4 Z-0.08
```

### 2.4. Mesh from first calibration on  2025-01-23

```gcode
Send: G29 S0
Recv: Mesh Bed Leveling ON
Recv: 5x5 mesh. Z offset: -0.12000
Recv: Measured points:
Recv:         0        1        2        3        4
Recv:  0 -0.04000 +0.02000 -0.00000 -0.03000 -0.10000
Recv:  1 +0.02000 +0.12000 +0.14000 +0.13000 +0.09000
Recv:  2 +0.02000 +0.13000 +0.17000 +0.12000 +0.08000
Recv:  3 +0.04000 +0.11000 +0.11000 +0.08000 +0.01000
Recv:  4 +0.07000 +0.12000 +0.08000 +0.02000 -0.09000
Recv:
Recv: X:133.17 Y:126.20 Z:42.85 E:53.28 Count X:10654 Y:10096 Z:17145
Recv: ok
```

## 3. ETX
