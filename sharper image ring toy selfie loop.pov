// PoVRay 3.7 Scene File " ... .pov"
// author:  @discatte (and nokia64 for the spincatte)
//   date:  March 2022
//  notes:  run with +KFF600 +KC
//          stuff above 'objects in scene' is povray boilerplate
//          with fog added
//--------------------------------------------------------------------------
#version 3.7;
global_settings{ assumed_gamma 1.0 }
#default{ finish{ ambient 0.1 diffuse 0.9
                  phong 1 reflection{ 0.00 metallic 0.00} 
         }} 
//--------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"
#include "transforms.inc"
//--------------------------------------------------------------------------
// camera ------------------------------------------------------------------
#declare Camera_0 = camera {perspective angle 75               // front view
                            location  <0.0 , 0.0 ,-2.0>
                            right     x*image_width/image_height
                            look_at   <0.0 , 0.0 , 0.0>}

#declare Camera_1 = camera {/*ultra_wide_angle*/ angle 90   // diagonal view
                            location  <2.0 , 2.5 ,-3.0>
                            right     x*image_width/image_height
                            look_at   <0.0 , 1.0 , 0.0>}
#declare Camera_2 = camera {/*ultra_wide_angle*/ angle 90  //right side view
                            location  <3.0 , 1.0 , 0.0>
                            right     x*image_width/image_height
                            look_at   <0.0 , 1.0 , 0.0>}
#declare Camera_3 = camera {/*ultra_wide_angle*/ angle 90        // top view
                            location  <0.0 , 3.0 ,-0.001>
                            right     x*image_width/image_height
                            look_at   <0.0 , 1.0 , 0.0>}
//camera{Camera_0}
//camera{Camera_C}
// sun ----------------------------------------------------------------------
light_source{< 3000,3000,-3000> color White}
// sky ----------------------------------------------------------------------
sky_sphere { pigment { gradient <0,1,0>
                       color_map { [0.00 rgb <0.6,0.7,1.0>]
                                   [0.35 rgb <0.1,0.0,0.8>]
                                   [0.65 rgb <0.1,0.0,0.8>]
                                   [1.00 rgb <0.6,0.7,1.0>] 
                                 } 
                       scale 2         
                     } // end of pigment
           } //end of skysphere


plane{<0,1,0>,1 hollow  
       texture{ pigment{ bozo turbulence 0.76
                         color_map { [0.5 rgb <0.20, 0.20, 1.0>]
                                     [0.6 rgb <1,1,1>]
                                     [1.0 rgb <0.5,0.5,0.5>]}
                       }
                finish {ambient 1 diffuse 0} }      
       scale 10000}
// fog ---------------------------------------------------------------------
fog{fog_type   2
    distance   100
    color      White
    fog_offset 5.00
    fog_alt    2.0
    turbulence 0.08}           
           
// ground -------------------------------------------------------------------

plane{ <0,1,0>, 0 
       texture{ pigment{ checker color rgb<1,1,1>*1.2 color rgb<0.25,0.15,0.1>*0}
              //normal { bumps 0.75 scale 0.025}
                finish { phong 0.1}
              } // end of texture
              translate<0,-1.5,0>
     } // end of plane
     
//---------------------------------------------------------------------------
//---------------------------- objects in scene ----------------------------
//---------------------------------------------------------------------------

// --- animation drivers ---

// 360 total rotation
// 90 degree offset between each part
#declare roti       = 360 * clock;
#declare rotoff     = 90;
#declare ring_count = 5;


// --- ring object ---

#macro ring_thing(ring_radius,ring_number)
 union {
  torus { ring_radius,0.05
        texture { pigment{ color rgbf<1,0,1,0>} finish { ior 0 }}
        scale <1,1,1> rotate<0,0,0> }
        
  sphere { <0,0, ring_radius>, 0.1 texture { pigment{ color rgb<0,0,1>} } }         
  sphere { <0,0,-ring_radius>, 0.1 texture { pigment{ color rgb<0,1,0>} } }
  
  cylinder { <0,0, ring_radius>,<0,0, ring_radius+0.2>, 0.03 texture { pigment { color rgb<0,1,1> } } rotate <0,90,0>}
  cylinder { <0,0,-ring_radius>,<0,0,-ring_radius-0.2>, 0.03 texture { pigment { color rgb<1,1,0> } } rotate <0,90,0>}

 }
#end


union {

// --- ring loop nest start ---

#declare II=ring_count;
#while (II>0)

#local ring_size = 0.2 * II; 

union {
  ring_thing(ring_size, II)
  
  // on inner most loop
  #if(II = 1)
   // --- center sphere ---
   //sphere { <0,0,0>, 0.1 pigment { checker color <1,1,1> color <1,0,0> translate <0.5,0,0.5> } }

   // --- selfie stick ---
   cylinder { <-0.07,0,-0.07>,<-0.1,1.1,-0.1>,0.005 pigment { rgb <1,0,0> } }
   sphere   { <0,1.1,0>, 0.01 texture { pigment{ color rgb<1,1,0>} } translate<-0.1,0,-0.1> }

  #end // if II = 1

 #declare II=II-1;
#end



// -- ring loop nest close brackets --- 
 
#declare II=ring_count;
#while (II>0) 

  rotate <roti,rotoff,0>
 }

 #declare II=II-1;
#end
     
 scale <1,1,1>*0.95   
 rotate <90,0,0>
 translate <0,0,0>
}



// --- camera test

#declare Camera_C = camera {

    perspective angle 75
    location  <0.0 , -0.0 , -1.2>
    right     x*image_width/image_height
    
    
    // camera orientation inside ring
    rotate <90,0,0>    
    
    // match ring transform stack                            
    #declare II=ring_count;
    #while (II>0) 
    
      rotate <roti,rotoff,0>
    
     #declare II=II-1;
    #end
    
    // final ring orientation
    rotate <roti*0+90,0,0>                           
}


camera {Camera_C}



// --- base ---
sphere { <0,-1.1,0>, 0.05 texture { pigment{ color rgb<1,0,0>} } }
sphere { <0, 1.1,0>, 0.05 texture { pigment{ color rgb<1,0,0>} } }



// --- original test ---
/*
union {
 ring_thing(1)
 
 union {
  ring_thing(0.8)
  
  union {
   ring_thing(0.6)
   
   union {
    ring_thing(0.4)
    
    union {
     ring_thing(0.2)
     sphere { <0,0,0>, 0.1 pigment { checker color <1,1,1> color <1,0,0> translate <0.5,0,0.5> } }
     rotate <roti,rotoff,0>
    }
     rotate <roti,rotoff,0>
   }
     rotate <roti,rotoff,0>   
  }  
     rotate <roti,rotoff,0>  
 }
 rotate <roti+90,45,0>
 translate <0,1.1,0>
}

*/