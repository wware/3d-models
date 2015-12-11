// Roller bearing

L1 = 60;
L2 = 20;
WALL = 3;
AXLE_DIAM = 5;
ROLLER_DIAM = 5;
FN=180;
GAP = 0.75;
FACTOR=0.75;

module inner() {
  translate([-L1/2, 0, 0])
    rotate([0, 90, 0])
      cylinder(d=AXLE_DIAM, h=L1, $fn=FN);
  translate([L2/2+GAP, 0, 0])
    rotate([0, 90, 0])
      cylinder(d=AXLE_DIAM+FACTOR*ROLLER_DIAM+GAP, h=WALL, $fn=FN);
  translate([-L2/2-GAP-WALL, 0, 0])
    rotate([0, 90, 0])
      cylinder(d=AXLE_DIAM+FACTOR*ROLLER_DIAM+GAP, h=WALL, $fn=FN);
}

module roller() {
  translate([-L2/2, (AXLE_DIAM+ROLLER_DIAM)/2+GAP, 0])
    rotate([0, 90, 0])
      cylinder(d=ROLLER_DIAM, h=L2, $fn=FN);
}

module case() {
  inner = 2*ROLLER_DIAM+AXLE_DIAM+4*GAP;
  outer = inner + 2*WALL;
  x = 2*ROLLER_DIAM+AXLE_DIAM+2*WALL+4*GAP;
  difference() {
    translate([-L2/2-GAP-1, 0, 0])
      rotate([0, 90, 0])
        cylinder(d=outer,
                 h=L2+2*GAP+2, $fn=FN);
    translate([-L2/2-2, 0, 0])
      rotate([0, 90, 0])
        cylinder(d=inner,
                 h=L2+2*GAP+4, $fn=FN);
  }
  difference() {
    union() {
      translate([L2/2+GAP, 0, 0])
        rotate([0, 90, 0])
          cylinder(d=outer, h=WALL, $fn=FN);
      translate([-L2/2-GAP-WALL, 0, 0])
        rotate([0, 90, 0])
          cylinder(d=outer, h=WALL, $fn=FN);
    }
    translate([-L2/2-15, 0, 0])
      rotate([0, 90, 0])
        cylinder(d=inner-FACTOR*ROLLER_DIAM, h=L2+30, $fn=FN);
  }
}

inner();

for (t = [0:60:359])
rotate([t, 0, 0])
roller();

case();
