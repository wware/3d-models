// M3D spool holder brackets.

/* This spool holder was designed March 19, 2015 by Erik van de Pol. It's available under the terms of the Create Commons CC-BY-SA license (http://creativecommons.org/licenses/by-sa/4.0/).
*/

/* [Global] */

// Which part would you like to see?
// part = "both"; // [clip:M3D base clip only,top:Axle holder only,both:Clip and axle holder,fullset:Full set of parts]
part = "fullset";

// Horizontal axle diameter in mm. This is where the spools rest on, and needs to be 6.25" in length.
shaft_diameter_h = 14;   // wood dowel is a little big
// Vertical shaft diameter in mm. These connect the top and bottom parts. These should be at least 3" in length, and can be taller to accomodate larger spool sizes.
shaft_diameter_v = shaft_diameter_h;

// Wall thickness for horizontal axle in mm. 
wall_thickness_h = 3; //[1.5,2,2.5,3,3.5,4]

// Wall thickness for vertical shaft in mm. This endures most of the stress, so recommended to not make this too thin.
wall_thickness_v = 3; //[1.5,2,2.5,3,3.5,4]

//Wall thickness for base clip. 1.5mm is a good starting value, as it allows for some flexibility to be able to put the clip on and off.
wall_thickness_c = 2.5; //[1,1.5,2,2.5,3]

// Cradle wall height for horizontal shaft in mm.
// This is the wall height for the horizontal axle cradle. You may want to increase this for larger axle diameters.
cradle_height = 5;

// Minimum contact area for horizontal shaft in mm.
// This can be useful for very thin horizontal axles, and ensures that there's enough area for the axle to rest on.
min_length_h = 20;


/* [Hidden] */
// the following are computed
shaft_depth = max(wall_thickness_v * 2 + shaft_diameter_v, min_length_h);

preview_tab = "";

print_part();

module print_part() {
	if (part == "clip") {
		clip_part_oriented();
	} else if (part == "top") {
		top_part_oriented();
	} else if (part == "both") {
		both();
	} else if (part == "fullset") {
		full_set();
	} else {
		both();
	}
}

module full_set()
{
  rotate([0,0,180]) both();
  both();
}

module both()
{
  translate([-12.75,wall_thickness_v + shaft_diameter_v/2 + 2.5,0]) {
    rotate([0,0,90]) clip_part_oriented();
    translate([7 + wall_thickness_c*2,0,0]) top_part_oriented();
  }
}

module clip_part_oriented()
{
  union() {
    translate([0,0,shaft_diameter_v/2 + wall_thickness_v]) {
      rotate([-90,0,0]) {
        bottom_v();
      }
    }
    bottom_contour();
  }
}

module bottom_v()
{
  difference() {
    cylinder(r=shaft_diameter_v/2 + wall_thickness_v, shaft_diameter_v, h=shaft_diameter_v,$fn=90);
    translate([0,0,-0.1]) {
      cylinder(r=shaft_diameter_v/2, shaft_diameter_v, h=shaft_diameter_v + 0.2,$fn=90);
    }
  }
}

module bottom_contour() {
  /*
   --------_
  |  _____  \
  | |w b   \  \
  | |_     r\  \
  |___|      \  |
            a|  |
          ___|  |
         |______|
  a = 15.1
  b = 13.75
  r = 12.75
  w = 3.5
  */
  translate([13.75+wall_thickness_c-wall_thickness_v-shaft_diameter_v/2,-12.75-wall_thickness_c+0.01,0]) 
  union() {
    // lip under
    translate([-13.73-wall_thickness_c,9.25-wall_thickness_c,0]) cube([wall_thickness_c+3, wall_thickness_c,shaft_diameter_v + wall_thickness_v*2]);    
    // lip side
    translate([-13.74-wall_thickness_c,9.25-wall_thickness_c,0]) cube([wall_thickness_c, wall_thickness_c*2+3.5,shaft_diameter_v + wall_thickness_v*2]);    
    // top
    translate([-13.75,12.75,0]) cube([13.75,wall_thickness_c, shaft_diameter_v + wall_thickness_v*2]);
    // curve
    intersection() {
      cube([12.75+wall_thickness_c+0.2,12.75+wall_thickness_c+0.2,shaft_diameter_v + wall_thickness_v*2 + 0.2]);
      difference() {
        cylinder(r=12.75+wall_thickness_c,h=shaft_diameter_v + wall_thickness_v*2,$fn=90);
        translate([0,0,-0.1]) cylinder(r=12.75,h=shaft_diameter_v + wall_thickness_v*2 + 0.2, $fn=90);
      }
    }
    // side
    translate([12.75,-15.1,0]) cube([wall_thickness_c, 15.1, shaft_diameter_v + wall_thickness_v*2]);
    // lower lip
    translate([9.75,-15.09-wall_thickness_c,0]) cube([3+wall_thickness_c, wall_thickness_c, shaft_diameter_v + wall_thickness_v*2]);
    
  }
}

module top_part_oriented()
{
  rotate([180,-90,0]) {
    translate([wall_thickness_v+shaft_diameter_v/2,0,0]) {
      top_part();
    }
  }
}

module top_part()
{
  difference() {
    union() {
      top_v();
      translate([-shaft_diameter_v/2 - wall_thickness_v,0, shaft_diameter_h/2 + wall_thickness_h + shaft_diameter_v]) {
        rotate([0,90,0]) {        
          top_h_out();
        }
      }
    }   
    translate([-shaft_diameter_v/2 - wall_thickness_v,0, shaft_diameter_h/2 + wall_thickness_h + shaft_diameter_v]) {
      rotate([0,90,0]) {
        top_h_in();
      }
    }
  }
}

module top_v()
{
  difference() {
    union() {
      cylinder(r=shaft_diameter_v/2 + wall_thickness_v, shaft_diameter_v, h=shaft_diameter_v,$fn=90);
      translate([0,0,shaft_diameter_v]) {
        cylinder(r1=shaft_diameter_v/2 + wall_thickness_v,r2=shaft_diameter_h/2 + wall_thickness_h, shaft_diameter_v, h=wall_thickness_h+shaft_diameter_h/2,$fn=90);
      }
    }
    translate([0,0,-0.1]) {
      cylinder(r=shaft_diameter_v/2, shaft_diameter_v, h=shaft_diameter_v + 0.1,$fn=90);
    }
  }
}

module top_h_out() {
  intersection() {
    union() {
      cylinder(r=shaft_diameter_h/2 + wall_thickness_h,h=shaft_depth,$fn=90);
      scale([cradle_height, shaft_diameter_h+wall_thickness_h*2, shaft_depth]) translate([-0.5,0,0.5]) cube(1,center=true);
    }
    translate([-cradle_height,0,0]) scale([shaft_diameter_h/2 + wall_thickness_h + cradle_height,shaft_diameter_h + wall_thickness_h*2,shaft_depth]) translate([0,-0.5,0]) cube(1);
  }
}

module top_h_in() 
{
  translate([0,0,wall_thickness_h]) {
    union() {
      cylinder(r=shaft_diameter_h/2,h=shaft_depth,$fn=90);
      scale([cradle_height+0.1, shaft_diameter_h, shaft_depth+0.1]) translate([-0.5,0,0.5]) cube(1,center=true);
    }
  }
}
        
  
