use <OpenForgeModule.scad>


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

module BoneMaze_floor_2x2() {
    OF_Floor(baseTextureIndex = 0) {
      scale([1, 1, OF_floor_texture_depth])
      import("WallOfBones_face.stl") ;
    }
}

module BoneMaze_wall_2x2() {

    OF_Wall(
      top_texture_index = 1,
      wall_texture_index = [0,0,1,1],
      wall_base_clip = [
        OF_base_height
        +OF_floor_texture_depth
        +OF_wall_texture_depth,
        0,0,0]
    
    ) {
      scale([1, 1, OF_wall_texture_depth])
      import("WallOfBones_face.stl") ;
      scale([1, 1, OF_wall_texture_depth])
      import("WallOfBones_edge.stl") ;
    }

    OF_Floor(
        wallClip = [0,OF_wall_thickness-OF_wall_texture_depth,0,0],
        baseTextureIndex = 0
    ) {
      scale([1, 1, OF_floor_texture_depth])
      import("WallOfBones_face.stl") ;
    }
}

BoneMaze_wall_2x2();


