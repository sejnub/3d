 // Case for Sonoff 10A Wifi Switch module
 
 
 cw = 55;       // case width
 cl = 140;      // case length
 cth = 2.5;     // case wall thickness
 play = 0.1;    // gap to easily fit case on top of bottom plate
 cthp = cth + play; 
 
 cih = 24.5;     // case inside height
 cil = cl-2*cth; // case inside length
 ciw = cw-2*cth; // case inside width

 
 ccr = 2;       // case corner radius
 bth = 2;       // thickness of bottom plate
 wth = 3;       // wall thickness for bottom plate (to hold sonoff module in place)
 wh  = 4.0;     // wall height for bottom plate
 
 sl = 89;       // length sonoff module
 sw = 40;       // width sonoff module
 
 eps = 0.01;    // compensate for rounding errors when using difference function
 2eps = 2*eps;
 
 
 module bottom_plate_wo_holes() {
 
     wol = sl+2*wth; // wall outside length
     wow = sw+2*wth; // wall outside width
     rcube(cl,cw,bth,ccr);
     
     difference() {
         translate([(cl-wol)/2,(cw-wow)/2,bth])cube([wol,wow,wh]);
         translate([(cl-sl)/2,(cw-sw)/2,bth-eps])cube([sl,sw,wh+2*eps]);
     }
         
     difference() {
         translate([cthp,cthp,bth])rcube(cil-2*play,ciw-2*play,4,ccr);
         translate([cthp+cth,cthp+cth,bth-eps])rcube(cil-2*cthp,ciw-2*cthp,4+2eps,ccr);
     }
     translate([cthp,(cw-20)/2,bth])strain_relief();
     translate([cl-cthp-10,(cw-20)/2,bth])strain_relief();
     
     // screw holes
     translate([4+cthp,4+cthp,0])cylinder(r=4,h=bth+wh, $fn=20);
     translate([cl-4-cthp,4+cthp,0])cylinder(r=4,h=bth+wh, $fn=20);
     translate([cl-4-cthp,cw-4-cthp,0])cylinder(r=4,h=bth+wh, $fn=20);
     translate([4+cthp,cw-4-cthp,0])cylinder(r=4,h=bth+wh, $fn=20);
 }
 
 module bottom_plate() {
     difference() {
        bottom_plate_wo_holes();
         
        // holes for screw head
        translate([4+cthp,4+cthp,-eps])cylinder(r=3.2,h=2.5, $fn=20);
        translate([cl-4-cthp,4+cthp,-eps])cylinder(r=3.2,h=2.5, $fn=20);
        translate([cl-4-cthp,cw-4-cthp,-eps])cylinder(r=3.2,h=2.5, $fn=20);
        translate([4+cthp,cw-4-cthp,-eps])cylinder(r=3.2,h=2.5, $fn=20);
         
        // holses for screw
        translate([4+cthp,4+cthp,-eps])cylinder(r=1.75,h=10, $fn=20);
        translate([cl-4-cthp,4+cthp,-eps])cylinder(r=1.75,h=10, $fn=20);
        translate([cl-4-cthp,cw-4-cthp,-eps])cylinder(r=1.75,h=10, $fn=20);
        translate([4+cthp,cw-4-cthp,-eps])cylinder(r=1.75,h=10, $fn=20);
     }
 }
         
 
 module case() {
     difference() {
        rrcube(cl,cw,cih+cth,ccr);
        translate([cth,cth,cth])rrcube(cil,ciw,cih+eps,ccr);
        
        // openings for cable on both sides
        translate([-eps,cw/2,cih+cth-11])rotate([0,90,0])cylinder(r=5, h=cth+2eps, $fn=20);
        translate([-eps,(cw/2)-5,cih+cth-11])cube([cth+2eps,10,11+eps]);
        
        translate([cl-cth-eps,cw/2,cih+cth-11])rotate([0,90,0])cylinder(r=5, h=cth+2eps, $fn=20);
        translate([cl-cth-eps,(cw/2)-5,cih+cth-11])cube([cth+2eps,10,11+eps]);
         
        // hole in top of case for push_button
        translate([66,15.5,-eps])cylinder(r=2.5, h=cth+2eps, $fn=20);
        translate([66,15.5,cth-1])cylinder(r=5, h=1+2eps, $fn=20);
        
        // Thin wall in top of case for LED to shine through
        translate([56,15.5,0.6])cylinder(r=2, h=cth+2eps, $fn=20);
         
        // alternatively, hole in top of case for LED, if case is not translucent
        //translate([56,15.5,-eps])cylinder(r=1.5, h=cth+2eps, $fn=20);
     }
     
     // cylincers for screws
     hs = cih-wh-0.2;
     x0 = 4+cthp;
     y0 = 4+cthp;
     x1 = cl-4-cthp;
     y1 = cw-4-cthp;
     translate([x0,y0,cth])screw_tube(hs);
     translate([x1,y0,cth])screw_tube(hs);
     translate([x1,y1,cth])screw_tube(hs);
     translate([x0,y1,cth])screw_tube(hs);
     
     // connect screw cylincers to sidewalls
     x2 = x0-0.75;
     y2 = y0-3-2.5;
     x3 = x1-0.75;
     y3 = y1+2.5;
     translate([x2,y2,bth])cube([1.5,3,hs]);
     translate([x3,y2,bth])cube([1.5,3,hs]);
     translate([x2,y3,bth])cube([1.5,3,hs]);
     translate([x3,y3,bth])cube([1.5,3,hs]);
     
     x4 = x0-3-2.5;
     y4 = y0-0.75;
     x5 = x1+2.5;
     y5 = y1-0.75;
     translate([x4,y4,bth])cube([3,1.5,hs]);
     translate([x5,y4,bth])cube([3,1.5,hs]);
     translate([x5,y5,bth])cube([3,1.5,hs]);
     translate([x4,y5,bth])cube([3,1.5,hs]);
 }
     
 module screw_tube(hs) {
     difference() {
         cylinder(r=3,h=hs, $fn=20);
         cylinder(r=1.6, h=hs, $fn=20);
     }
 }
 
 // cube with rounded corners on vertical edges
  module rcube(l,w,h,r) {
      hull() {
          translate([r,r,0])cylinder(r=r, h=h, $fn=20);
          translate([l-r,r,0])cylinder(r=r, h=h, $fn=20);
          translate([l-r,w-r,0])cylinder(r=r, h=h, $fn=20);
          translate([r,w-r,0])cylinder(r=r, h=h, $fn=20);
      }
  }
  
  // cube with rounded corners on vertical edges and bottom side of horizontal edges
  module rrcube(l,w,h,r) {
      x0=0;
      x1=l-2*r;
      y0=0;
      y1=w-2*r;
      hull() {
         translate([x0,y0,0])rrcube_profile(h,r);
         translate([x1,y0,0])rrcube_profile(h,r); 
         translate([x1,y1,0])rrcube_profile(h,r); 
         translate([x0,y1,0])rrcube_profile(h,r);  
      }
  }
  
  
  module rrcube_profile(h,r) {
       translate([r,r,r])hull() {
            sphere(r=r,$fn=30);
            cylinder(r=r,h=h-r,$fn=20);
       }
  }
  
  
  module strain_relief() {
      difference() {
        translate([0,0,0])cube([10,20,10]);        
        translate([-eps,10,10])rotate([0,90,0])cylinder(r=4.75, h=10+2eps, $fn=20);
        translate([3.25,10,11])rotate([0,90,0])rotate_extrude(convexity=10) translate([7,0,0]) square([2.5,3.5]);
      }
      strain_relief_notch();
  }
  
  module strain_relief_notch() {
      difference() {
        translate([5,0,4])rotate([0,45,0])translate([-2,0,-2])cube([4,20,4]);
        translate([3.25,10,11])rotate([0,90,0])rotate_extrude(convexity=10) translate([7,0,0]) square([2.5,3.5]);
      }
  }
  
  module push_button() {
     translate([0,0,0])cylinder(r=2, h=cth+1, $fn=20);
     translate([0,0,0])cylinder(r=4.5, h=1, $fn=20);
  }
      

bottom_plate();
translate([0,cw+10,0])
  case();
translate([0,-10,0])
  push_button();
  




    
 

      
  