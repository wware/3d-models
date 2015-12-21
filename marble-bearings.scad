SCREW_DIAM = 5;  // 6-32 machine screw
MARBLE_DIAM = 15.8;
GAP = 0.5;
WALL = 3;
AXLE_DIAM = 6;
FN = 180;
L = 90;
OFS = 15;

module cyl(d, h) {
  translate([-h/2, 0, 0])
    rotate([0, 90, 0])
      cylinder(h=h, d=d, $fn=FN);
}

module marbles() {
  for (t = [0:60:359])
    rotate([t, 0, 0])
  translate([0, MARBLE_DIAM+GAP, 0])
    sphere(d=MARBLE_DIAM, $fn=FN);
}


module cone(r, L) {
  d = 2 * r;
  rotate([0, 90, 0])
    intersection() {
      translate([-L-d, -L-d, 0])
        cube([2*(L+d), 2*(L+d), 2*L]);
      difference() {
         cylinder(h=L, r1=L+d/2, r2=d/2, $fn=FN);
         translate([0, 0, -sqrt(2)*WALL])
           cylinder(h=L+d/2, r1=L+d/2, r2=0, $fn=FN);
      }
    }
}

module concave(r, L) {
  translate([-L, 0, 0])
    cone(r, L);
  rotate([0, 0, 180])
    translate([-L, 0, 0])
      cone(r, L);
}

module convex(r, L) {
  r = r + sqrt(2) * WALL;
  cone(r, L);
  rotate([0, 0, 180])
    cone(r, L);
}

module shaft(feet) {
  a = (1 - 0.5*sqrt(2)) * MARBLE_DIAM + GAP;
  cyl(AXLE_DIAM, L);
  concave(a, MARBLE_DIAM/2);
  H = 6;
  g = MARBLE_DIAM / 2 + 2 * WALL;
  if (feet)
    for (x = [-1:2:1.1])
      translate([x*(MARBLE_DIAM/2), 0, -H - g])
        cylinder(d1=1, d2=0.2, h=H+1, $fn=12);
}

module dual_y() {
  for (i = [0 : 1 : $children-1]) {
    children(i);
    mirror([0, 1, 0]) children(i);
  }
}

module cage(feet) {
  Z = 200;
  a = (0.5 + 0.5*sqrt(2)) * MARBLE_DIAM + 2*GAP;
  intersection() {
    translate([-Z/2, -Z/2, 0])
      cube([Z, Z, Z]);
    convex(a, MARBLE_DIAM/2);
  }
  difference() {
    translate([-0.5*MARBLE_DIAM, -3*MARBLE_DIAM])
      cube([MARBLE_DIAM, 6*MARBLE_DIAM, WALL]);
    rotate([0, 90, 0])
      cylinder(h=MARBLE_DIAM, r1=a+MARBLE_DIAM/2, r2=a, $fn=FN);
    translate([0.01, 0, 0])
      rotate([0, -90, 0])
        cylinder(h=MARBLE_DIAM, r1=a+MARBLE_DIAM/2, r2=a, $fn=FN);
    for (j = [-1:2:1.1])
      translate([0, 2.5 * j * MARBLE_DIAM, -5])
        cylinder(d=SCREW_DIAM, h=WALL+10, $fn=FN);
  }
  H = 6;
  if (feet)
    for (x = [-1:2:1.1])
      translate([0, x*(MARBLE_DIAM*3), -H])
        cylinder(d1=1, d2=0.2, h=H+0.1, $fn=12);
}

module visualize() {
  shaft(0);
  %marbles();
  cage(0);
}

module print() {
  for (x=[0:1:1.1])
    translate([x*1.1*MARBLE_DIAM, 0, 0]) cage(1);
  a = (0.5 + 0.5*sqrt(2)) * MARBLE_DIAM + 2*GAP;
  translate([-1.5*MARBLE_DIAM, 0, a-6])
    rotate([0,0,90])
      shaft(1);
}

if (1)
  print();
else
  visualize();
