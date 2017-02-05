
/**
 * These constants size OpenForge tiles. They are used as defaults in the modules.
 *
 * The constants are taken from examination of the OpenForge source code.
 */

// width of an openforge floor square.
OF_square = 25; // 25mm. Use 25.4 if you want them to be exactly an inch.
// height of am openforge wall, from 0 to the top of the texture 
OF_wall_height = 50; 
// height of the openforge base chunk
OF_base_height = 7.5;
// width of the groove between floor tiles
OF_groove_width = .65;
// thickness of an OF wall, including the thicknesses of the textures
OF_wall_thickness = 10.2;
// depth from the top of the base texture to the top of the base
OF_floor_texture_depth = 3.7;
// inset from the outer limit of the wall size to the base if the wall texture
OF_wall_texture_depth = 1;

// tickness of floor texture 
// the "smooth" pagage uses 2mm, other bits use 3.7 . 
// I think that what's hoing on is that the floor texture has a 
// main riser and an upper smaller bit 

// so I will generate a chamfer from the lower .65mm gap to the upper 2mm gap

OF_floorTexUpper = 3.7; // from openforge
OF_floorTexLower = 2; // from openforge

// gap between floor tiles, in theory
OF_floorGapLower = .65; // from openforge
OF_floorGapUpper = 2; // wall texture * 2


/**
 * This module builds a 2*2 openforge floor section.
 * A texture for the floor may be passed as a child node. If no texture is given, then a
 * blank 2mm high texture (same as openforge_smooth) will be used.
 *
 * Use the baseNegativeIndex to specify a child shape that is cut out of the base.
 * This shape is clipped to the base with a wall thickness given by baseWallThickness. 
 *
 * Use the baseTextureIndex to specify which child node is the base texture. 
 *
 * Openforge textures appear to be 3.7mm high, so size your textures to match that.
 *
 * The texture is positioned vertcally. This module assumes that the XY of the texture
 * match the floor xy. 
 *
 * Textures are not clipped vertically. This  means that by giving a base texture
 * with features extending above the 2mm mark, taller features may be included. The
 * overall height of a sourceforge wall is 25mm, but keep in mind that any base texture is
 * vertically translated by the base thickness (7.5mm)
 * 
 * The edges and grooves of the floor tile are subtratced from the texture. This means
 * that your texture should not run right up to the edge of the tile unless you 
 * disable the grooves.
 * 
 * The texture can be clipped to accomodate an OF_Wall piece. The cliping is specified
 * as an arry of wall thichnesses in NSEW order, where "south-west" is the origin
 *
 * The default measurements are taken from the openforge source, correct for 2*2 25mm blocks.
 */

module OF_Floor(
    floorXY = [OF_square*2, OF_square*2],
    containingZ = OF_wall_height, // used to incise the grooves
    baseHeight = OF_base_height,
    baseWallThickness = OF_square/10, // overrides the base negative texture 
    baseTextureIndex = -1, // <0 means no base texture
    baseNegativeIndex = -1,
    use_grooves = true,
    groove_width = OF_groove_width,
    floorBlocks = [2, 2],
    wallClip = [0, 0, 0, 0],
    floorTexLower = OF_floorTexLower,
    floorTexUpper = OF_floorTexUpper,
    floorGapLower = OF_floorGapLower,
    floorGapUpper = OF_floorGapUpper
) {
    // I'll make these into constants
    N = 0;
    S = 1;
    E = 2;
    W = 3;

  difference() {
      
      union() {
          // base 
          cube([floorXY[0], floorXY[1], baseHeight]);
          
          // base texture
          translate([0,0,baseHeight])
          difference() {
              if(baseTextureIndex < 0) {
                  cube([floorXY[0], floorXY[1], floorTexUpper]);
              }
              else {
                  children([baseTextureIndex]);
              }
              
              union() {
                  if(wallClip[N]>0) { // north
                      translate([0,floorXY[1]-wallClip[N],0])
                      cube([floorXY[0], wallClip[N], containingZ-baseHeight]);
                  }
                  if(wallClip[S]>0) { // south
                      cube([floorXY[0], wallClip[S], containingZ-baseHeight]);
                  }
                  if(wallClip[E]>0) { // east
                      translate([floorXY[0]-wallClip[E],0,0])
                      cube([wallClip[E], floorXY[1], containingZ-baseHeight]);
                  }
                  if(wallClip[W]>0) { // west
                      cube([wallClip[W], floorXY[1], containingZ-baseHeight]);
                  }
              }
          }
      }
      
      if(baseNegativeIndex >= 0) {
          intersection() {
            cube([floorXY[0], floorXY[1], baseHeight]);
            children(baseNegativeIndex);
          }
      }
      
      if(use_grooves) {
        translate([0,0,baseHeight]) {
          for(x=[0:floorBlocks[0]])
          translate([x * floorXY[0]/floorBlocks[0], 0, 0]) {
            translate([-floorGapLower/2,0,0])
            cube([floorGapLower, floorXY[1], containingZ-baseHeight]);
            translate([-floorGapUpper/2,0,floorTexUpper])
            cube([floorGapUpper, floorXY[1], containingZ-baseHeight-floorTexUpper]);

            // chamfer
            translate([0,floorXY[1],0])
            rotate(90,[1,0,0])
            linear_extrude(floorXY[1])
            polygon([
                [-floorGapLower/2, floorTexLower],
                [floorGapLower/2, floorTexLower],
                [floorGapUpper/2, floorTexUpper+.01],
                [-floorGapUpper/2, floorTexUpper+.01]
            ]);
          }
          for(y=[0:floorBlocks[1]])
            translate([0, y * floorXY[1]/floorBlocks[1], 0]) {
            translate([0, -floorGapLower/2, 0])
            cube([floorXY[0], floorGapLower, containingZ-baseHeight]);
            translate([0, -floorGapUpper/2, floorTexUpper])
            cube([floorXY[0], floorGapUpper, containingZ-baseHeight-floorTexUpper]);
            // chamfer
            rotate(90,[0,0,1])
            rotate(90,[1,0,0])
            linear_extrude(floorXY[0])
            polygon([
                [-floorGapLower/2, floorTexLower],
                [floorGapLower/2, floorTexLower],
                [floorGapUpper/2, floorTexUpper+.01],
                [-floorGapUpper/2, floorTexUpper+.01]
            ]);
          }
        }
      }
  } 

  // the base wall. This effectively clips the base negative texture

  difference() {
    cube([floorXY[0], floorXY[1], baseHeight]);
    translate([baseWallThickness,baseWallThickness,-baseWallThickness])
    cube([floorXY[0]-baseWallThickness*2, floorXY[1]-baseWallThickness*2, baseHeight]);
  }

  
}

/*
  the default parameters 

  an OF wall has an XYZ size given as a vector.
  The wall has north, south, east and west faces, a top, and a base height.
  Positive along the Y axis is north, and positive along the X axis is east.
  Various paramters for these walls are passed as vectors. These vectors are assumed to be
  in order NSEW.
  
  Each side of a wall may be flush or textured.
  Textures are treated as being INSET into the wall. This does not mean that they are 
  specified in the negative, just that textures are assumed to not protrude beyond where the 
  wall would be if it were flush.

  Each wide of a wall, if it is textured, may have the texture clipped at the base to 
  accomodate a floor. This is given as a measurment - each side may have its own clip height.

  Textures are specified as a child object.
  The z-direction of the texture becomes the relief - it will be rotated so as to point "out".
  The origin of the texture will become the top left point of the wall. This means that the 
  x-axis of the texture becomes the vertical axis of the wall. Think of them as bing "hung"
  from the wall.

  
  textures are assumed to be sized according to the size and height of the wall. If you 
  specifiy that the x domension of your wall is 50, it will be assumed that your texture is
  50 across.

  if adjacent corners are textured, then the texture on both will be clipped inwards by the
  texture depth. The textures are not resized to fit. This means that you dont get some weird
  intersection happenning at the corners.

  The default paramters for this module give a wall that is sized as a 25mm open forge wall
  two squares long, along the X axis, with a recess for a floor on the north side

*/
module OF_Wall(
  size = [OF_square*2, OF_wall_thickness, OF_wall_height],
  texture_depth = OF_wall_texture_depth,
  top_flush = false,
  wall_flush = [false, false, false, false],
  wall_base_clip = [0,0,0,0],
  top_flush = false,
  top_texture_index = -1,
  wall_texture_index = [-1, -1, -1, -1]
) 
{
    // I'll make these into constants
    N = 0;
    S = 1;
    E = 2;
    W = 3;
    
    // I'm getting zero-thickness artifacts, so I need to add a fudge factor
    // to the clipping cubes
    shave = texture_depth / 1000;
    shave1 = texture_depth + shave;
    shave2 = texture_depth + shave * 2;
    
    translate([
        wall_flush[W] ? 0 : texture_depth,
        wall_flush[N] ? 0 : texture_depth,
        0
    ])    
    
    cube([
        size[0] - (wall_flush[E] ? 0 : texture_depth)  - (wall_flush[W] ? 0 : texture_depth) ,
        size[1] - (wall_flush[N] ? 0 : texture_depth)  - (wall_flush[S] ? 0 : texture_depth) ,
        size[2] - (top_flush ? 0 : texture_depth)
    ]);
    
    difference() {
        union() {
            if(!top_flush) {
                translate([0,0,size[2] - texture_depth])
                if(top_texture_index >= 0) {
                    children(top_texture_index);
                }
                else {
                    cube([
                        size[0], size[1], texture_depth
                    ]);
                }
            }
            if(!wall_flush[N]) {
                translate([size[0],size[1]-texture_depth,size[2]])
                rotate(90, [0,0,1])
                rotate(90, [0,1,0])
                difference() {
                    if(wall_texture_index[N] >= 0) {
                        children(wall_texture_index[N]);
                    }
                    else {
                        cube([
                            size[2], size[0], texture_depth
                        ]);
                    }
                    if(wall_base_clip[N] > 0) {
                        translate([size[2]-wall_base_clip[N],0,-shave])
                        cube([wall_base_clip[N], size[0], shave2]); 
                    }
                }
            }
            if(!wall_flush[S]) {
                translate([0,texture_depth,size[2]])
                rotate(-90, [0,0,1])
                rotate(90, [0,1,0])
                difference() {
                    if(wall_texture_index[S] >= 0) {
                        children(wall_texture_index[S]);
                    }
                    else {
                        cube([
                            size[2], size[0], texture_depth
                        ]);
                    }
                    
                    if(wall_base_clip[S] > 0) {
                        translate([size[2]-wall_base_clip[S],0,-shave])
                        cube([wall_base_clip[S], size[0], shave2]); 
                    }
                }
            }
            if(!wall_flush[E]) {
                translate([size[0]-texture_depth,0,size[2]])
                rotate(90, [0,1,0])
                difference() {
                    if(wall_texture_index[E] >= 0) {
                        children(wall_texture_index[E]);
                    }
                    else {
                        cube([
                            size[2], size[1], texture_depth
                        ]);
                    }

                    if(wall_base_clip[E] > 0) {
                        translate([size[2]-wall_base_clip[E],0,-shave])
                        cube([wall_base_clip[E], size[1], shave2]); 
                    }
                }
            }
            if(!wall_flush[W]) {
                translate([texture_depth,size[1],size[2]])
                rotate(180, [0,0,1])
                rotate(90, [0,1,0])
                difference() {
                    if(wall_texture_index[W] >= 0) {
                        children(wall_texture_index[W]);
                    }
                    else {
                        cube([
                            size[2], size[1], texture_depth
                        ]);
                    }
                    if(wall_base_clip[W] > 0) {
                        translate([size[2]-wall_base_clip[W],0,-shave])
                        cube([wall_base_clip[W], size[1], shave2]); 
                    }
                }
            }
        }
        
        // and now for the seams between the textures
        
        if(!top_flush && !wall_flush[N]) {
            translate([0, size[1]-shave1, size[2]-shave1])
            cube([size[0], shave2, shave2]);
        }
        if(!top_flush && !wall_flush[S]) {
            translate([0, -shave, size[2]-shave1])
            cube([size[0], shave2, shave2]);
        }
        if(!top_flush && !wall_flush[E]) {
            translate([size[0]-shave1, 0, size[2]-shave1])
            cube([shave2, size[1], shave2]);
        }
        if(!top_flush && !wall_flush[W]) {
            translate([-shave, 0, size[2]-shave1])
            cube([shave2, size[1], shave2]);
        }
        
        if(!wall_flush[N] && !wall_flush[E]) {
           translate([size[0]-shave1,size[1]-shave1,0])
           cube([shave2,shave2,size[2]]);
        }
        if(!wall_flush[N] && !wall_flush[W]) {
           translate([-shave,size[1]-shave1,0])
           cube([shave2,shave2,size[2]]);
        }
        if(!wall_flush[S] && !wall_flush[E]) {
           translate([size[0]-shave1,-shave,0])
           cube([shave2,shave2,size[2]]);
        }
        if(!wall_flush[S] && !wall_flush[W]) {
           translate([-shave,-shave,0])
           cube([shave2,shave2,size[2]]);
        }
    }
}


// these test shapes are deliberately assymnetric
// and extend all the way to the corners, to help
// demonstrate where clipping happens
// the poky-out pyramid helps us confirm that the textures are 
// oriented correctly WRT in/out of the surface
// note that because our pryamid excceds the state texture height, the clipping
// of the texture at the corners doe not happen correctly. This is to be expected.
// if you use wall textures that extend in the z-direction beyond the surface of the wall,
// then caveat emptor.

module OF_testTexture() {
    linear_extrude(1)
    scale([1/3, 1/3, 1])
    polygon([[0,0],[1,1],[3,0],[2,2],[3,3],[1.5,2.5],[0,3],[1,2]]);
    
    hull() {
    translate([2/6,1/6,0]) cube([.01, .01, 3]);
    translate([0/3, 0/3, 0])
    cube([2/3,1/3,.01]);
    }
}

module OF_testFloorTexture() {
    scale([OF_square*2,OF_square*2,OF_floor_texture_depth]) OF_testTexture();
}

module OF_testWallTexture() {
    scale([OF_wall_height,OF_square*2,OF_wall_texture_depth]) OF_testTexture();
}

module OF_testEdgeTexture() {
    scale([OF_wall_height,OF_wall_thickness,OF_wall_texture_depth]) OF_testTexture();
}

OF_Floor(baseTextureIndex = 0, wallClip=[0,OF_wall_thickness - OF_wall_texture_depth,0,0]) {
    OF_testFloorTexture();
}

OF_Wall(wall_texture_index = [0, 0, 1, 1], top_texture_index=1
, wall_base_clip = [
    OF_base_height + OF_floor_texture_depth + OF_wall_texture_depth,
    
    10, 20, 30

  ]) {
    OF_testWallTexture();
    OF_testEdgeTexture();
}
