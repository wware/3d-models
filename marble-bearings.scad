SCREW_DIAM = 4;  // 6-32 machine screw
MARBLE_DIAM = 16;
GAP = 0.75;
WALL = 3;
AXLE_DIAM = 5;
FN = 180;
L = 90;
OFS = 15;

module cyl(d, h) {
  translate([-h/2, 0, 0])
  rotate([0, 90, 0])
  cylinder(h=h, d=d, $fn=FN);
}

module ring(d1, d2, h) {
  difference() {
    cyl(d2, h);
    translate([-1, 0, 0])
    cyl(d1, h+3);
  }
}

module shaft() {
  cyl(AXLE_DIAM, L);
  for (h = [-1:2:1.1]) {
    translate([h*OFS, 0, 0]) {
      cyl(MARBLE_DIAM, WALL);
      cyl(AXLE_DIAM+WALL, MARBLE_DIAM);
    }
  }
}

module marbles() {
  for (t = [0:60:359])
    rotate([t, 0, 0])
  for (h = [-OFS:2*OFS:1.1*OFS])
    translate([h, 1.02*MARBLE_DIAM, 0])
      sphere(d=MARBLE_DIAM, $fn=FN);
}

module cage() {
  for (h = [0:60:359])
    rotate([h, 0, 0])
    translate([0, 0, MARBLE_DIAM-WALL/2])
      intersection() {
        translate([-2*L, -2*L, 0])
          cube([4*L, 4*L, 4*L]);
        rotate([0, 0, 90])
          ring(MARBLE_DIAM+2*GAP, MARBLE_DIAM+2*WALL+2*GAP, WALL);
      }
  ring(3*MARBLE_DIAM-WALL+2*GAP, 3*MARBLE_DIAM+WALL+2*GAP, WALL);
  for (h = [-1:2:1.1]) {
    translate([h*(MARBLE_DIAM/2+WALL/2+GAP), 0, 0])
      union() {
        ring(2*MARBLE_DIAM-WALL, 2*MARBLE_DIAM+WALL, WALL);
        ring(AXLE_DIAM+GAP, AXLE_DIAM+2*WALL+GAP, WALL);
        for (t = [0:90:359])
          rotate([t + 45, 0, 0])
            translate([-WALL/2, (AXLE_DIAM+WALL)/2, -WALL/2])
              cube([WALL, MARBLE_DIAM-AXLE_DIAM/2, WALL]);
      }
  }
}

module cage2() {
  L2 = L + OFS - 30;
  H = 3 * MARBLE_DIAM + 13;
  difference() {
    translate([-L2/2, -H/2, 0])
      cube([L2, H, WALL]);
    for (h = [-OFS:2*OFS:1.1+OFS])
      translate([h-MARBLE_DIAM/2-GAP, -1.5*MARBLE_DIAM, -1])
        cube([MARBLE_DIAM+2*GAP, 3*MARBLE_DIAM, WALL+2]);
    translate([-L/2, -(AXLE_DIAM/2+GAP), -1])
      cube([L, AXLE_DIAM+2*GAP, WALL+2]);
    for (h = [-1:1:1.1])
      for (j = [-1:2:1.1])
        translate([h*(L2/2-1.5*SCREW_DIAM), j*(H/2-1.5*SCREW_DIAM), -1])
          cylinder(d=SCREW_DIAM, h=WALL+2, $fn=FN);
  }
  intersection() {
    translate([-2*L, -2*L, 0])
      cube([4*L, 4*L, 4*L]);
    for (h = [-1:2:1.1])
      translate([h*OFS, 0, 0]) cage();
  }
}

// %shaft();
// %marbles();
cage2();

