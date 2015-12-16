SCREW_DIAM = 5;  // 6-32 machine screw
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

module marbles() {
  for (t = [0:60:359])
    rotate([t, 0, 0])
  for (h = [-OFS:2*OFS:1.1*OFS])
    translate([h, MARBLE_DIAM+2*GAP, 0])
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
  cone(r, L);
  rotate([0, 0, 180])
    cone(r, L);
}

module shaft() {
  a = (1 - 0.5*sqrt(2)) * MARBLE_DIAM + GAP;
  cyl(AXLE_DIAM, L);
  for (h = [-1:2:1.1]) {
    translate([h*OFS, 0, 0])
      concave(a, MARBLE_DIAM/2);
  }
}

module dual_y() {
  for (i = [0 : 1 : $children-1]) {
    children(i);
    mirror([0, 1, 0]) children(i);
  }
}

module cage() {
  Z = 200;
  a = 1.5 * MARBLE_DIAM + 2.5 * GAP;
  intersection() {
    translate([-Z/2, -Z/2, 0])
    cube([Z, Z, Z]);
    for (h = [-1:2:1.1]) {
      translate([h*OFS, 0, 0])
        convex(a, MARBLE_DIAM/2);
    }
  }

  l = 5 * OFS;
  c = a - 2.4*WALL;
  r = 0.75*MARBLE_DIAM;
  dual_y()
  difference() {
    union() {
      translate([-l/2, a - WALL, 0])
        cube([l, 15, WALL]);
    }
    for (j = [-1:2:1.1])
      translate([j*OFS, 0, 0]) {
        translate([-0.1, 0, 0])
          rotate([0, 90, 0])
            cylinder(h=r, r1=r+c, r2=c, $fn=FN);
        rotate([0, -90, 0])
          cylinder(h=r, r1=r+c, r2=c, $fn=FN);
    }
    translate([-OFS, 0, 0]) {
      translate([-0.1, 0, 0])
        rotate([0, 90, 0])
          cylinder(h=r, r1=r+c, r2=c, $fn=FN);
      rotate([0, -90, 0])
        cylinder(h=r, r1=r+c, r2=c, $fn=FN);
    }
    for (i = [-1:1:1.1]) {
      translate([i*2*OFS, 32, -5])
        cylinder(d=SCREW_DIAM, h=15, $fn=FN);
    }
  }
}

shaft();
%marbles();
cage();
