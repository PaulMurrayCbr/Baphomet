
$fn=48;

D = 45;
R = D/2;
H = 1;

HH = H * 2;

spacing = R/10;
thickness = spacing * .616;

function xof(r, y) = 
  sqrt(1 - y/r*y/r) * r
;

function outerR(i) =  R - i * spacing - spacing/2 + thickness/2;

function innerR(i) =  R - i * spacing - spacing/2 - thickness/2;

function upperY(i) = i*spacing + thickness/2;

function lowerY(i) = i*spacing - thickness/2;

module chop1() {
    translate([0,0,-HH/2]) 
    
    translate([0,0,-HH/2]) 
    linear_extrude(HH*2)
    polygon([
    
    
     [xof(r=outerR(7), y = upperY(-.5)), upperY(-.5)],
     [xof(r=outerR(7), y = lowerY(.5)), lowerY(.5)],

     [xof(r=innerR(7), y = upperY(0)), upperY(0)],


     [xof(r=outerR(7), y = upperY(.5)), upperY(.5)],
     [xof(r=outerR(7), y = lowerY(1.5)), lowerY(1.5)],
    
     [xof(r=innerR(6), y = lowerY(1.5)), lowerY(1.5)],
     [xof(r=outerR(6), y = upperY(1.5)), upperY(1.5)],
    
     [xof(r=innerR(5), y = lowerY(2.5)), lowerY(2.5)],
     [xof(r=outerR(5), y = upperY(2.5)), upperY(2.5)],
    
     [xof(r=innerR(4), y = lowerY(3.5)), lowerY(3.5)],
     [xof(r=outerR(4), y = upperY(3.5)), upperY(3.5)],

     [xof(r=(innerR(3)+outerR(4))/2, y = upperY(3.75)), upperY(3.75)],
    
     [xof(r=innerR(3), y = upperY(3.5)), upperY(3.5)],
     [xof(r=outerR(3), y = lowerY(3.5)), lowerY(3.5)],
    
     [xof(r=innerR(2), y = upperY(2.5)), upperY(2.5)],
     [xof(r=outerR(2), y = lowerY(2.5)), lowerY(2.5)],
    
     [xof(r=innerR(1), y = upperY(1.5)), upperY(1.5)],
     [xof(r=outerR(1), y = lowerY(1.5)), lowerY(1.5)],
    
     [xof(r=innerR(0), y = upperY(.5)), upperY(.5)],
     [xof(r=outerR(0), y = lowerY(.5)), lowerY(.5)],

     [xof(r=innerR(-1), y = lowerY(.5)), lowerY(.5)],
     [xof(r=innerR(-1), y = upperY(-.5)), upperY(-.5)],

     [R+ thickness, (upperY(-.5) + lowerY(-.5))/2],
     
     [xof(r=innerR(-1), y = lowerY(-.5)), lowerY(-.5)],
     [xof(r=innerR(-1), y = upperY(-1.5)), upperY(-1.5)],


    
//     [R+ thickness, upperY(-.5)],
//     [R+ thickness, lowerY(-.5)],
     
     [xof(r=outerR(0), y = upperY(-1.5)), upperY(-1.5)],
     [xof(r=innerR(0), y = lowerY(-1.5)), lowerY(-1.5)],
     
     [xof(r=outerR(1), y = upperY(-2.5)), upperY(-2.5)],
     [xof(r=innerR(1), y = lowerY(-2.5)), lowerY(-2.5)],
     
     [xof(r=outerR(2), y = upperY(-3.5)), upperY(-3.5)],
     [xof(r=innerR(2), y = lowerY(-3.5)), lowerY(-3.5)],

     [xof(r=(innerR(2)+outerR(3))/2, y = lowerY(-3.75)), lowerY(-3.75)],

     
     [xof(r=outerR(3), y = lowerY(-3.5)), lowerY(-3.5)],
     [xof(r=innerR(3), y = upperY(-3.5)), upperY(-3.5)],

     [xof(r=outerR(4), y = lowerY(-2.5)), lowerY(-2.5)],
     [xof(r=innerR(4), y = upperY(-2.5)), upperY(-2.5)],

     [xof(r=outerR(5), y = lowerY(-1.5)), lowerY(-1.5)],
     [xof(r=innerR(5), y = upperY(-1.5)), upperY(-1.5)],

     [xof(r=outerR(6), y = lowerY(-.5)), lowerY(-.5)],
     [xof(r=innerR(6), y = upperY(-.5)), upperY(-.5)]

    ]) ;
}

module chop2() {
    translate([0,0,-HH/2]) 
    linear_extrude(HH*2)
    polygon([
      
     [innerR(3.25), 0],
    
     [xof(r=innerR(3), y = lowerY(.5)), lowerY(.5)],
     [xof(r=outerR(3), y = upperY(.5)), upperY(.5)],
    
     [xof(r=innerR(2), y = lowerY(1.5)), lowerY(1.5)],
     [xof(r=outerR(2), y = upperY(1.5)), upperY(1.5)],
    
     [xof(r=(outerR(2)+innerR(1))/2, y = upperY(1.75)), upperY(1.75)],


     [xof(r=innerR(1), y = upperY(1.5)), upperY(1.5)],
     [xof(r=outerR(1), y = lowerY(1.5)), lowerY(1.5)],
    
     [xof(r=innerR(0), y = upperY(.5)), upperY(.5)],
     [xof(r=outerR(0), y = lowerY(.5)), lowerY(.5)],

     [outerR(-.25), 0],
    
     [xof(r=outerR(0), y = upperY(-.5)), upperY(-.5)],
     [xof(r=innerR(0), y = lowerY(-.5)), lowerY(-.5)],
    
     [xof(r=outerR(1), y = upperY(-1.5)), upperY(-1.5)],
     [xof(r=innerR(1), y = lowerY(-1.5)), lowerY(-1.5)],
    
     [xof(r=(outerR(2)+innerR(1))/2, y = lowerY(-1.75)), lowerY(-1.75)],
    
    
     [xof(r=outerR(2), y = lowerY(-1.5)), lowerY(-1.5)],
     [xof(r=innerR(2), y = upperY(-1.5)), upperY(-1.5)],
    
     [xof(r=outerR(3), y = lowerY(-.5)), lowerY(-.5)],
     [xof(r=innerR(3), y = upperY(-.5)), upperY(-.5)],
    
    
    
    ]);
}

module chop3() {
    translate([0,0,-HH/2]) 
    linear_extrude(HH*2)
    polygon([
      
     [innerR(4.25), 0],
    
     [xof(r=innerR(4), y = lowerY(.5)), lowerY(.5)],
     [xof(r=outerR(4), y = upperY(.5)), upperY(.5)],
    
     [xof(r=innerR(3), y = lowerY(1.5)), lowerY(1.5)],
     [xof(r=outerR(3), y = upperY(1.5)), upperY(1.5)],
    
     [xof(r=(outerR(3)+innerR(2))/2, y = upperY(1.75)), upperY(1.75)],


     [xof(r=innerR(2), y = upperY(1.5)), upperY(1.5)],
     [xof(r=outerR(2), y = lowerY(1.5)), lowerY(1.5)],
    
     [xof(r=innerR(1), y = upperY(.5)), upperY(.5)],
     [xof(r=outerR(1), y = lowerY(.5)), lowerY(.5)],

     [outerR(.75), 0],
    
     [xof(r=outerR(1), y = upperY(-.5)), upperY(-.5)],
     [xof(r=innerR(1), y = lowerY(-.5)), lowerY(-.5)],
    
     [xof(r=outerR(2), y = upperY(-1.5)), upperY(-1.5)],
     [xof(r=innerR(2), y = lowerY(-1.5)), lowerY(-1.5)],
    
     [xof(r=(outerR(3)+innerR(2))/2, y = lowerY(-1.75)), lowerY(-1.75)],
    
    
     [xof(r=outerR(3), y = lowerY(-1.5)), lowerY(-1.5)],
     [xof(r=innerR(3), y = upperY(-1.5)), upperY(-1.5)],
    
     [xof(r=outerR(4), y = lowerY(-.5)), lowerY(-.5)],
     [xof(r=innerR(4), y = upperY(-.5)), upperY(-.5)],
    
    
    
    ]);
}

module pathStraight(a=-3.5, b=3.5) {
    for(i=[a:b]) {
        translate([0,i*spacing,0])
        translate([0,-thickness/2,0])
        cube([R+thickness,thickness,HH]);
    }
}

module wallStraight(a=-3.5, b=3.5) {
    for(i=[a:b]) {
        translate([0,i*spacing,0])
        translate([0,-(spacing-thickness)/2,0])
        cube([R+thickness,(spacing-thickness),HH]);
    }
}

module walls() {
    difference() {
        for(i=[0:7]) {
            difference() {
                cylinder(r = innerR(i-1),h = HH);
                translate([0,0,-HH/2])
                cylinder(r = outerR(i), h = HH *2);
            }
        }
        chop1();
        rotate(120,[0,0,1]) chop2();
        rotate(240,[0,0,1]) chop3();
    }
    
    intersection() { 
        wallStraight(a=-4, b=4); 
        chop1(); 
    }
    rotate(120,[0,0,1]) intersection() {
        wallStraight(a=-3, b=3); 
        chop2();
    }
    rotate(240,[00,0,1]) intersection() { 
        wallStraight(a=-3, b=3); 
        chop3(); 
    }
}

module path() {
    difference() {
        for(i=[0:6]) {
            difference() {
                cylinder(r = outerR(i), h = HH);
                translate([0,0,-HH/2])
                cylinder(r = innerR(i), h = HH *2);
            }
        }
        chop1();
        rotate(120,[0,0,1]) chop2();
        rotate(240,[0,0,1]) chop3();
    }
    
    intersection() { 
        pathStraight(a=-3.5, b=3.5); 
        chop1(); 
    }
    rotate(120,[0,0,1]) intersection() {
        pathStraight(a=-1.5, b=1.5);
        chop2();
    }
    rotate(240,[00,0,1]) intersection() { 
        pathStraight(a=-1.5, b=1.5); 
        chop3(); 
    }
    
    cylinder(r=outerR(7), h=HH);
}


translate([25,25,0]) {
//color("blue", .25) 
     walls();
     
}

scale([1,1,2])
import("WallOfBones_lorez_50_50_1.stl");



