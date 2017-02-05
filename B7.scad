///////////////
// baphomet symbol measurements

/* baphomet6 is a bit different. The inner pentagram and the outer 
circle do not intersect, but meet at a point. The diameter 
of the image is this intersection point.

In this file and the others I have done, SigilD is the outer radius of the ring, beyond which the sprues extend. This means that sizing the image correctly is a bit of a thing and dpeends in the witdth of that outer ring
*/


imageSize = 337;

sigilD = 75; 
// dimensions of the cylindrical sprue on the sigil which will conduct light from the neopixel
sigilSprueLen = 5;
// distance in from the sigilD outer ring. Our ring is about 6 pixels wide
sigilSprueInner = 0;
sigilSprueD = 4;

sigilR = sigilD/2;


z  = sigilD/imageSize; // the image is 298 pixels square

ringThick = 3; 

module head() {
    translate([0,2,0])
    translate([ringThick,ringThick,0])
    scale((sigilD-ringThick*2)/337)
    scale([1,1,ringThick*20/255])
    translate([0,0,-2])
    surface("B6.png");
}

module sprue() {
    translate([sigilR, sigilR, 0]) {
        rotate_extrude($fn = 144)
        translate([sigilD/2-ringThick/2,0,0]) 
        square(ringThick, center=true);
                
        for(th=[0:360/5:360-1])  rotate(th+36, [0,0,1]) 
            {
            rotate(-18, [0,0,1])
            translate([0,0,-ringThick/2])
                hull() {
                translate([-sigilD/2+ringThick,0,0]) {
                    cube([ringThick/sin(360/20),.1,ringThick]);
                    
                }
                rotate(144,[0,0,1])
                translate([-sigilD/2+ringThick,0,0]) {
                    cube([ringThick/sin(360/20),.1,ringThick]);
                    
                }
            }
        }
        

        for(th=[0:360/5:360-1])  rotate(th+36, [0,0,1]) 
            {
            hull() {
                translate([0,sigilR-8,0])
                rotate(-90, [1,0,0]) {
                translate([0,0,-sigilSprueInner]) 
                    cylinder(h=.1, d=sigilSprueD*.1, $fn=48);
                }
           
                translate([0,sigilR,0])
                rotate(-90, [1,0,0]) {
                translate([0,0,-sigilSprueInner]) 
                    cylinder(h=sigilSprueLen+sigilSprueInner, d=sigilSprueD, $fn=48);
                }
            }
        }
    }
}

scale([1,-1,1])
intersection() { 
    union() {
        sprue(); 
        head();
    }
    translate([-sigilSprueLen, -sigilSprueLen, 0])
    cube([sigilD+sigilSprueLen*2,sigilD+sigilSprueLen*2,sigilD]); 
}
