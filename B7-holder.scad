/*

Neopixel holder.

This object will hold sections of a nepixel strip in order to illuminate a
bahoment sigil. The sigil itself will be in clear PLA.

*/


// a general slop factor

clearance = .25;

$fn = 288;

///////////////
// neopixel strip measurements


// measured along the strip
neopixelWidth = 4.85 + clearance*2;
// measured across the strip
neopixelHeight = 4.90 + clearance*2;
// distance from the back of the backing strip to the front of the neopixel;
neopixelDepth = 1.85 + clearance;
// I assume the lens is centered on the body of the unit
neopixelLensDiameter = 3.64+clearance;

//backingStripThickness = .3;
backingStripThickness = .4;
// interval between neopixels. We assume that a neopixel is centered on this distance.
backingStripLength = 33.05 + clearance * 2;
backingStripWidth = 10.04 + clearance;
// each end of the strip as 3 conductors, spaced this far apart. Don't know if I am going to need this measurement.
backingStripConductorSpacing = 2.36;

///////////////
// baphomet symbol measurements

sigilD = 75; 
// dimensions of the cylindrical sprue on the sigil which will conduct light from the neopixel
sigilSprueLen = 5;
sigilSprueD = 4;

sigilR = sigilD/2;

// connecting Wire will be three strands of ribbon cable

connectingWireWidth = 2.5;
connectingWireDepth = .5;;



// this is the thicknesss of the frame from the pintn where the sprue
// butts up agains the LED, inwards. It must be <= sigilSprueLen, or else the holder
// will interfere with the sigil
sprueHolderDepth = 1.5;
sprueHolderThickness = 1.5;

resistorIndentationLength = 10;
resistorIndentationDepth = 1.5;
resistorIndentationWidth = 3;

// dimentiojsn for supporting webbing
wiggleThick = .2;    // thickness of the webbing
wiggleClearance = wiggleThick*2; // zig-zag overhang
wiggleSpacing = 2; // space between zig-zags

// gap between the support and the material it supports
// I am taking this fro the Slic3r support generation page. 
// aparrentl;y it;s ok to have a gap
wiggleDepthClearance = .2;

// overall depth of the frame.
frameDepth = backingStripWidth + 3; 


stripRad = sigilR + sigilSprueLen + neopixelDepth;



module sigilMockup() {
    rotate_extrude()
    translate([sigilR-2.5,0,0])
    circle(d=5, $fn=12);
    
    for(theta=[0:360/5:360-1]) {
        rotate(360/5*theta-90, [0,0,1])
        hull() {
            translate([sigilR-2.5,0,0])
            sphere(d=5, $fn=12);
            
            rotate(360/5*2, [0,0,1])
            translate([sigilR-2.5,0,0])
            sphere(d=5, $fn=12);
        }
        
        rotate(360/5*theta-90, [0,0,1])
        translate([sigilR,0,0])
        rotate(90, [0,1,0])
        cylinder(h=sigilSprueLen, d=sigilSprueD);
    }
}


function arcAtR1toHeightAtR2(arc, r1, r2) = 
    sin(arc / r1 /2/PI * 360)
    /cos(arc / r1 /2/PI * 360)
    * r2;



    

module chopper(chopwidth) {
    chopRad = stripRad + 5;
    backingStripHalfProjected = arcAtR1toHeightAtR2(
        arc=chopwidth/2, 
        r1=stripRad, 
        r2=chopRad);
    translate([0,0,-5])
    for(theta=[0:360/5:360-1]) 
    rotate(360/5*theta, [0,0,1])
    linear_extrude(frameDepth+10)
    polygon([
        [0,0], 
        [-backingStripHalfProjected,-chopRad], 
        [backingStripHalfProjected,-chopRad]
    ]);
}

module neopixels() {
    for(theta=[0:360/5:360-1]) 
    rotate(360/5*theta+36, [0,0,1]) {
        translate([-neopixelWidth/2,sigilR+sigilSprueLen,frameDepth/2-neopixelHeight/2])
        cube([neopixelWidth, neopixelDepth, neopixelHeight ]);
        
        // there's  a little resistor there as well
        
        translate([
                -resistorIndentationLength/2,
                stripRad-resistorIndentationDepth,
                frameDepth/2-resistorIndentationWidth/2])
        cube([resistorIndentationLength, 
                resistorIndentationDepth+1, 
                resistorIndentationWidth ]);
        
    }
    
    
    intersection() {
        translate([0,0,(frameDepth-backingStripWidth)/2])
        difference() {
            cylinder(h=backingStripWidth, r=stripRad);
            translate([0,0,-5])
            cylinder(h=backingStripWidth+10, r=stripRad - backingStripThickness);
        }
        chopper(backingStripLength);
    }
    
}

module sprues() {
    for(theta=[0:360/5:360-1]) 
    rotate(360/5*theta, [0,0,1]) 
    rotate(90, [1,0,0])  {
        cylinder(h=100, d=sigilSprueD, $fn = 12);
        hull() {
            cylinder(h=sigilR+sigilSprueLen, d=sigilSprueD, $fn = 12);
            translate([0, 20, 0])
            cylinder(h=sigilR+sigilSprueLen, d=sigilSprueD, $fn = 12);
        }
    }
}


/////////////////
// ok - that completes the description of what this item must conform to.
// from here down is the design of a solution


module mainRing() {
    difference() 
    {
        union() {
            cylinder(r=stripRad - backingStripThickness,          h=//neopixelHeight
                frameDepth);
            cylinder(h=(frameDepth-backingStripWidth)/2, 
            r=stripRad +backingStripThickness+2);

    *        translate([0,0,frameDepth/2+backingStripWidth/2])
            cylinder(h=(frameDepth-backingStripWidth)/2, 
                    r=stripRad +           backingStripThickness+2);
        }
        
        translate([0,0,-5])
        cylinder(r=sigilR + sigilSprueLen-sprueHolderDepth, 20);
        translate([0,0,frameDepth/2]) sprues();
        neopixels();
    }
    
}

module sprueHolderWebbing() {
    translate([-wiggleThick/2, -wiggleThick/2, 0])
    cube([wiggleThick,wiggleThick,frameDepth/2-sigilSprueD/2-sprueHolderThickness-wiggleDepthClearance]);
}

module sprueHolders() {
    holderD = sigilSprueD + sprueHolderThickness*2;
    
    for(th=[0:360/5:360-1]) rotate(th,[0,0,1]) {
        translate([0,-sigilR,frameDepth/2]) {
            difference() {
                translate([-holderD/2,-sigilSprueLen,-holderD/2])
                cube([holderD,sigilSprueLen, holderD/2]);
                
                rotate(90, [1,0,0])
                cylinder(d=sigilSprueD, h=100, center=true);
            }
            
            translate([sigilSprueD/2,-sigilSprueLen,-holderD/2])
            cube([sprueHolderThickness,sigilSprueLen,holderD]);
            translate([-sigilSprueD/2-sprueHolderThickness,-sigilSprueLen,-holderD/2])
            cube([sprueHolderThickness,sigilSprueLen,holderD]);
        }
        
        
    // support for the sprue holders
//wiggleThick = .25;    
//wiggleClearance = 1;
    
        for(d = [sigilD/2:wiggleSpacing:sigilD/2+sigilSprueLen-wiggleSpacing-wiggleClearance]) 
            translate([0,-d,0]) {
                
            hull() {
                translate([holderD/2+wiggleClearance,0,0])
                sprueHolderWebbing();
                translate([-holderD/2-wiggleClearance,-wiggleSpacing/2,0])
                sprueHolderWebbing();
            }
            hull() {
                translate([-holderD/2-wiggleClearance,-wiggleSpacing/2,0])
                sprueHolderWebbing();
                translate([holderD/2+wiggleClearance,-wiggleSpacing,0])
                sprueHolderWebbing();
            }
        }
    }
    
}

module holderRing() {
  difference() {
  cylinder(h=frameDepth, r=stripRad +backingStripThickness+2);
      translate([0,0,-5])
  cylinder(h=frameDepth + 10, r=stripRad +backingStripThickness);
  }
}

module wireRingWebbing() {
    translate([-wiggleThick/2, -wiggleThick/2,0])
    cube([wiggleThick,wiggleThick,(frameDepth-connectingWireWidth)/2-1-wiggleDepthClearance]);
}

module holder() {
    intersection()
    {
        union () {    
            mainRing();
            difference() {
            holderRing();
            chopper(resistorIndentationLength + 2);
            }
        }
        chopper(resistorIndentationLength + 6);
    }

    // supporting wire ring
    difference() 
    {
        union() {
            difference() {
                translate([0,0,(frameDepth-connectingWireWidth)/2-1])
                    cylinder(r=sigilR + sigilSprueLen + neopixelDepth - backingStripThickness,          h=connectingWireWidth+2);
                chopper(resistorIndentationLength);
            }

            difference() {
                union() {
                    translate([0,0,(frameDepth-connectingWireWidth)/2-1])
                        cylinder(r=stripRad - backingStripThickness+1,          h=1);
                *  translate([0,0,(frameDepth+connectingWireWidth)/2])
                        cylinder(r=stripRad - backingStripThickness+1,          h=1);
                }
                chopper(backingStripLength);
            }
        }

        translate([0,0,-5])
        cylinder(r=sigilR + sigilSprueLen - sprueHolderDepth, 20);
    }
    
    sprueHolders();

// support for the connecting wire ring
    for(tt=[0:360/5:360-1]) {
        w = 18;    
        g = 360 / (sigilR*2*PI/wiggleSpacing);
        
        for(th=[-w-g:g:w]) {
            hull() {
                rotate(th+tt, [0,0,1]) 
                translate([0,sigilR + sigilSprueLen-sprueHolderDepth-wiggleClearance,0])
                wireRingWebbing();
                rotate(th+tt+g/2, [0,0,1]) 
                translate([0,stripRad+wiggleClearance,0])
                wireRingWebbing();
            }
            hull() {
                rotate(th+tt+g, [0,0,1]) 
                translate([0,sigilR + sigilSprueLen-sprueHolderDepth-wiggleClearance,0])
                wireRingWebbing();
                rotate(th+tt+g/2, [0,0,1]) 
                translate([0,stripRad+wiggleClearance,0])
                wireRingWebbing();
            }
        }
    }
}

module holderClip() {
    holderD = sigilSprueD + sprueHolderThickness*2;
    difference() {
        translate([-sigilSprueD/2,0,0])
        union() {
            cube([sigilSprueD, holderD/2, sigilSprueLen]);
            cube([sigilSprueD, frameDepth/2, sprueHolderDepth]);
        }

        cylinder(d=sigilSprueD, h=100, center=true);    
    }
}


module 100pcarb() {
cylinder(d=102, h=3.2);
}

module 75halfsilver() {
cylinder(d=75, h=3.2);
}

module 75Mirror() {
cylinder(d=75, h=1.4);
}

module 100Mirror() {
cylinder(d=100, h=1.35);
}

color("green", .25)
100Mirror();

color("grey", .25)
mainRing();

* color("red", 0.25)
 translate([0,0,frameDepth/2]) sigilMockup();

*color("blue", 0.25)
frameBoundingBox();

*color("magenta", .25)
neopixels();



//holder();
//holderClip();
