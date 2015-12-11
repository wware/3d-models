H = 5;
W = 3;
D = 8;
OUTER = 55;
INNER = OUTER - 2*W;

translate([-OUTER/2, -W/2, 0])
cube([OUTER, W, H]);

intersection() {
    translate([-50, 0,0])
    cube([100, 50, 50]);
    difference() {
        cylinder(h=H, d=OUTER, $fn=200);
        translate([0, 0, -1])
        cylinder(h=H+2, d=INNER, $fn=200);
    }
}

for (t = [0:4])
    rotate([0, 0, 30*(t+1)]) {
        translate([0, -W/2, 0])
        cube([INNER/2 - D/2, W, H]);
        translate([INNER/2 - D/2 - t / 4, 0, 0])
        cylinder(h=H, d=D, $fn=200);
    }
