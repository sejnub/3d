# 3D Printers

- [1. Anycubic Mega S](#1-anycubic-mega-s)
  - [1.1. Marlin Firmware](#11-marlin-firmware)
  - [1.2. Checklist](#12-checklist)
  - [1.3. OctoPrint](#13-octoprint)
    - [1.3.1. Octolapse](#131-octolapse)
  - [1.4. Bed Levelling](#14-bed-levelling)
  - [1.5. Bed adhesion](#15-bed-adhesion)
    - [1.5.1. My tries](#151-my-tries)
      - [1.5.1.1. Bambu Studio / Initial Layer: height and width](#1511-bambu-studio--initial-layer-height-and-width)
    - [1.5.2. General advice from Perplexity](#152-general-advice-from-perplexity)
    - [1.5.3. Z-Offset](#153-z-offset)
  - [1.6. Temp](#16-temp)
- [2. Other Printers](#2-other-printers)
  - [2.1. Models](#21-models)
    - [2.1.1. Sovol SV06 ACE](#211-sovol-sv06-ace)
  - [2.2. ETX](#22-etx)

## 1. Anycubic Mega S

### 1.1. Marlin Firmware

- <https://github.com/knutwurst/Marlin-2-0-x-Anycubic-i3-MEGA-S>

- <https://github.com/knutwurst/Marlin-2-0-x-Anycubic-i3-MEGA-S/wiki/Set-new-print-bed-size>

### 1.2. Checklist

V1

- In Bambu
  - Add discs to edges

- At printer
  - clean space for moving parts!
  - Switch on Printer!
  - Preheat printer!
  - empty the bed!
  - level the bed! (in preheated state)
    - preheat
    - home
    - motor off
  - clean bed (alcohol)!

- In Bambu
  - First layer height ~ 2.7 mm
  - Supports are sliced

- In Hass
  - For Octolapse
    - Camera is oriented and focussed
      - Reocam is set to `printbed3`

- In OctoPrint
  - OctoPrint is connected to printer `/dev/ttyUSB0`

- In Bambu
  - Click `Print`!

- In Hass
  - Watch first layer
  - Fine tune Camera focus

### 1.3. OctoPrint

#### 1.3.1. Octolapse

- [Octolapse](https://all3dp.com/2/octoprint-timelapse-how-to-find-the-best-octolapse-settings/)

- Reolink
  - E1 Zoom
    - Snapshot
      - <http://192.168.1.96/cgi-bin/api.cgi?cmd=Snap&channel=0&rs=dummy1&user=admin&password=admin-password>
        - With `admin-password` replaced with the actual value
    - Stream
      - <rtsp://admin:admin-password@192.168.1.96:554/h264Preview_01_main>

- In slicer settings, I selected the slicer-option which contained the slicer that Bambu slicer was forked from

- No extruding after first (or second?) layer
  - Question: my printer stopped extruding while printing with Octolapse turned on
  - Answer: Firmware settings: In Octolapse, edit your printer profile and set "G90/G91 Influences Extruder" to "True" under Firmware Settings5.

### 1.4. Bed Levelling

- [Perfektes Bett-Leveling beim Anycubic i3 Mega](https://cool-web.de/3d-druck/anycubic-i3-mega-bett-leveling.htm)
- [5 squares with 0.2mm height for bed leveling test](https://www.thingiverse.com/thing:2780118)

### 1.5. Bed adhesion

#### 1.5.1. My tries

##### 1.5.1.1. Bambu Studio / Initial Layer: height and width

- ILH := Quality / Layer height / Initial layer height
  - Orig: 0.2 mm

- ILW := Quality / Line width / Initial layer
  - Orig: 0.42 mm

- Manual levelling: double paper sheet middle resistance at rim

- Tries
  - Try 1
    - ILH: 0.3 mm
    - ILW: orig == 0.42mm

#### 1.5.2. General advice from Perplexity

user
are there settings in Bambu studio that can help to reduce bed adhesion?

assistant
In Bambu Studio, or any similar 3D printing software, managing bed adhesion can be crucial for successful prints. Here are a few settings and tips you can adjust in Bambu Studio to reduce bed adhesion if necessary:

1. **Bed Temperature**: Lowering the bed temperature can help reduce adhesion. Experiment with decreasing the temperature in small increments until you find a balance that prevents excessive sticking but still allows the print to adhere during printing.

2. **Z Offset**: Increasing the Z offset slightly can help by raising the nozzle further from the bed on the first layer, which may reduce adhesion.

3. **First Layer Height and Speed**: Increasing the first layer height or reducing the first layer printing speed can help manage adhesion. A thicker layer might have less tendency to stick too firmly, and a slower speed ensures accurate placement without excessive pressure.

4. **Use of Skirt or Brim**: If you're using a brim, consider switching to a skirt or reducing the brim's size. This can help ease removal by minimizing unnecessary contact area.

5. **Adhesion Type**: Try changing the adhesion type. Switching from a raft or brim to a skirt can reduce bed contact and therefore adhesion.

6. **Cooling**: Increasing fan speed during the first layers can help the filament cool faster and reduce the chance of it fusing too strongly to the bed.

7. **Surface Preparation**: Ensure the bed's surface is clean but also consider using a release agent like a thin layer of glue stick or painter's tape to make bed removal easier.

Remember to make adjustments gradually and test frequently to find the optimal settings for your specific printer and material combination.

#### 1.5.3. Z-Offset

- <https://forum.bambulab.com/t/how-to-do-multi-z-offset-settings-for-filaments-bed-plates/50794>
- <https://makerworld.com/de/models/19385#profileId-21308>

### 1.6. Temp

;Profil Homepage: https://github.com/NilsRo/Cura_Anycubic_MegaS_Profile

;Slicer Information - (Support for OctoPrint Slicer Estimator)
;Slicer info:material_guid;{material_guid}
;Slicer info:material_id;{material_id}
;Slicer info:material_brand;{material_brand}
;Slicer info:material_name;{material_name}
;Slicer info:filament_cost;{filament_cost}
;Slicer info:material_bed_temperature;{material_bed_temperature}
;Slicer info:material_bed_temperature_layer_0;{material_bed_temperature_layer_0}
;Slicer info:material_print_temperature;{material_print_temperature}
;Slicer info:material_print_temperature_layer_0;{material_print_temperature_layer_0}
;Slicer info:material_flow;{material_flow}
;Slicer info:layer_height;{layer_height}
;Slicer info:machine_nozzle_size;{machine_nozzle_size}
;Slicer info:wall_thickness;{wall_thickness}
;Slicer info:speed_print;{speed_print}
;Slicer info:speed_topbottom;{speed_topbottom}
;Slicer info:travel_speed;{travel_speed}
;Slicer info:support;{support}
;Slicer info:retraction_speed;{retraction_speed}
;Slicer info:retraction_amount;{retraction_amount}
;Slicer info:layer_height;{layer_height}
;Slicer info:infill_pattern;{infill_pattern}
;Slicer info:infill_sparse_density;{infill_sparse_density}
;Slicer info:cool_fan_enabled;{cool_fan_enabled}
;Slicer info:cool_fan_speed;{cool_fan_speed}
;Slicer info:sliced_at;{day} {date} {time}
G21                                        ; metric values
G90                                        ; absolute positioning
M82                                        ; set extruder to absolute mode
M900 K0                                    ; disable lin. adv. if not set in GCODE
M107                                       ; start with the fan off
M140 S{material_bed_temperature_layer_0}   ; Start heating the bed
G4 S60                                     ; wait 1 minute
M104 S{material_print_temperature_layer_0} ; start heating the hot end
M190 S{material_bed_temperature_layer_0}   ; wait for bed
M109 S{material_print_temperature_layer_0} ; wait for hotend
M300 S1000 P500                            ; BEEP heating done
G28 X0 Y10 Z0                              ; move X/Y to min endstops
M420 S1                                    ; Enable leveling
M420 Z2.0                                  ; Set leveling fading height to 2 mm
G0 Z0.15                                   ; lift nozzle a bit
G92 E0                                     ; zero the extruded length
G1 X150 E40 F500                            ; Extrude 20mm of filament in a 5cm line.
G92 E0                                     ; zero the extruded length again
G1 E-2 F500                                ; Retract a little
G1 X50 F500                                ; wipe away from the filament line
G1 X100 F9000                              ; Quickly wipe away from the filament line

## 2. Other Printers

### 2.1. Models

#### 2.1.1. Sovol SV06 ACE

### 2.2. ETX
