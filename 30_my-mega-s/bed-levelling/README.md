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

### 2.2. Mesh von erster Kalibrierung am 2025-02-08

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

### 2.3. Mesh von erster Kalibirerung am 2025-01-23

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
