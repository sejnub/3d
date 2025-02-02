# Bed Levelling


## Manual Mesh

- Via Marlin LCD Menu
  - <https://www.youtube.com/shorts/1-UEWbcggMo>
  - <https://www.youtube.com/watch?v=B_rkGoc3aTE&ab_channel=iTryTec>

> Entered the GCode

### gcode 2

The following is insereted into `Bambu Studio / Printer settings / Machine start G-code` directly __after__ `G28`

```gcode
; hb begin instructions to use the mesh
M501 ; hb load all saved settings from eeprom
M420 S1 ; hb switch bed levelling on
G29 S4 Z-0.12
; hb end instructions to use the mesh
```

### Mesh von erster Kalibirerung am 20ä25-01-23

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

## ETX
