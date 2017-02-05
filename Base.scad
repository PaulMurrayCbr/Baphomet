
// a bit of an experiment in using an operator module. All the measurments
// are "known" by battery_holder_cavity, and things that use battery_holder_cavity
// don't have to know exactly where the wires exit in order to be able to
// link them up with the "hull" operator.

/*
A cavity into which I can mount one of these. 
https://www.jaycar.com.au/4-x-c-cell-2-rows-of-2-end-to-end-battery-holder/p/PH9216
The battery holder has a couple of screwholes in the base.
The cavity has the xy centered at the origin, and is longer in the x direction.
The cavity sits as z=0, but extends a little below this to avoid coplanar
surfaces when it is subtracted from a volume.

The wires come out from the cavity at the x end.

If position=exit is true, then instead of drawing a cavity, this module
will draw child module 0 centered at a reasonable point for wire routing to start.
This allows you to use hull to make a connecting channel for the wire
of the shape you choose.

*/



module battery_holder_cavity(position_exit = false) {
    
    // dimensions taken from the object
    holder_length = 108.34;
    holder_height = 28.11;
    holder_width = 53.65;
    
    wire_exit_width = 9.2;
    wire_exit_height = 7;
    wire_thickness = 1.5; // with some slop
    
    // my dimensions
    // don't want the batteries actually resting on the floor
    height_off_floor = 2; 
    // leave a bit of a gap so I can actually insert the holder in the cavity
    edge_play = 1;
    // extend the cavity downwards to zap coplanar surfaces
    coplanar_shave = 0.1;

        if(!position_exit) {
            translate([
                (holder_length + edge_play * 2)/-2,
                (holder_width + edge_play * 2)/-2,
                -coplanar_shave
            ])
            cube([
                holder_length + edge_play * 2,
                holder_width + edge_play * 2,
                holder_height + height_off_floor + coplanar_shave
            ]);
    
            translate([
                (holder_length + edge_play * 2)/2+wire_thickness/2,
                0,
                height_off_floor + holder_height - wire_exit_height
            ])
            cube([wire_thickness,wire_exit_width,wire_thickness], center = true);
        }
        else {
            translate([
            holder_length/2+edge_play+wire_thickness,
            0,
            height_off_floor + holder_height - wire_exit_height
            ])
            children(0);
        }
}

// this thing is a gap for the wires to pass through. It's sized to admit
// the headers on the end of the wire that I currently have soldered to the 
// battery.

module wire_channel() {
    cube([3,6,3], center=true);
}

module holder_body() {
    rad = 6;
difference() {
    translate([rad,rad,0])
    minkowski() {
        cube([25*5 - rad*2 , 25*3 -rad*2 , 25 * 1.5 -rad]);
        sphere(r=rad, $fn = 24);
    }
    translate([0,0,-rad-1])
        cube([25*5, 25*3 , rad+1]);
}
}



rotate(180,[1,0,0])
difference()  {
    holder_body();
    translate([25*2.5, 25*1.5, 0]) {
        battery_holder_cavity();
        hull() {
            battery_holder_cavity(position_exit=true) wire_channel();
            translate([25*2.5, 0, 25*1.5-1.5]) wire_channel();
        }
    }
 }
 
