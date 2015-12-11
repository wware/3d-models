INCH = 25.4;

L = 0.6 * INCH;
W = 0.2 * INCH;
H = 0.1 * INCH;

translate([-L/2, -W/2, 0])
cube([L, W, H]);

translate([-W/2, -L/2, 0])
cube([W, L, H]);
