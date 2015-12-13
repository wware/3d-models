SCREW_DIAM = 4;  // 6-32 machine screw
MARBLE_DIAM = 16;
GAP = 0.75;
WALL = 3;
AXLE_DIAM = 5;
FN = 60;
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

module torus(r1, r2) {
  rotate_extrude(convexity=10, $fn=FN)
  translate([r1, 0, 0])
    circle(r=r2, $fn=FN);
}

module shaft() {
  cyl(AXLE_DIAM, L);
  for (h = [-1:2:1.1]) {
    translate([h*OFS, 0, 0]) {
      difference() {
        cyl(1.5*MARBLE_DIAM, MARBLE_DIAM-GAP);
        rotate([0, 90, 0])
            torus(MARBLE_DIAM, MARBLE_DIAM/2);
      }
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
  difference() {
    rotate([0, 90, 0])
      torus(MARBLE_DIAM, MARBLE_DIAM/2+WALL);
    cyl(d=2.3*MARBLE_DIAM, h=L);
    rotate([0, 90, 0])
      torus(MARBLE_DIAM, MARBLE_DIAM/2);
  }
}

module cage2() {
  L2 = L + OFS - 35;
  H = 3 * MARBLE_DIAM + 12;

  // base plate
  difference() {
    translate([-L2/2, -H/2, 0])
      cube([L2, H, WALL]);
    // cut-outs for marbles
    for (h = [-OFS:2*OFS:1.1+OFS])
      translate([h, 0, 0])
        rotate([0, 90, 0])
          torus(MARBLE_DIAM, MARBLE_DIAM/2);
    // large cut-out around axle
    translate([-L/2, -2.3*MARBLE_DIAM/2, -1])
      cube([L, 2.3*MARBLE_DIAM, WALL+2]);
    // screw holes
    for (h = [-1:1:1.1])
      for (j = [-1:2:1.1])
        translate([2*h*OFS, j*(H/2-1.5*SCREW_DIAM), -1])
          cylinder(d=SCREW_DIAM, h=WALL+2, $fn=FN);
  }
  intersection() {
    // upper half of cage
    translate([-2*L, -2*L, 0])
      cube([4*L, 4*L, 4*L]);
    for (h = [-1:2:1.1])
      translate([h*OFS, 0, 0]) cage();
  }
}

// shaft();
// %marbles();
cage2();
