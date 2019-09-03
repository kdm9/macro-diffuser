base_w = 50; // width of collar, mm
base_h = 40; // height of collar, mm
base_d = 20;
diffuse_w = 100;
diffuse_h = 80;
diffuse_d = 30;
diffuse_rad = 300;
w_diff = (diffuse_w-base_w);
h_diff = (diffuse_h-base_h);
total_d = base_d + diffuse_d;
bx = -0.5*w_diff;
by = -0.5*h_diff;
wall = 1;
fudge = 0.01;

module quarter_round(l, r) {
    intersection() {
        cylinder(h=l, r=r);
        cube([r, r, l]);
    }

}


module rect_cone(x, y) {
    r = x / 2;
    intersection() {
        union() {
            translate([r, y, 0]) 
                  rotate([90, 0, 0])
                  quarter_round(y, r);
            translate([r, y, 0]) 
                  rotate([90, -90, 0])
                  quarter_round(y, r);
        }
        union() {
            translate([0, y-r, 0]) 
                  rotate([90, 0, 90])
                  quarter_round(x, r);
            translate([0, r, 0]) 
                  rotate([90, -90, 90])
                  quarter_round(x, r);
            translate([0, r, 0])
                cube([x, y-2*r, r]);
        }
    }
}

module diffuser() {
    union() {
        // Base
        difference() {
            cube([base_w+2*wall, base_h+2*wall, base_d]);
            translate([wall, wall, -fudge])
                cube([base_w, base_h, base_d+2*fudge]);
        }
        // Snout
        difference() {
            polyhedron([[0,                     0,                     base_d],
                        [base_w+2*wall,         0,                     base_d],
                        [base_w+2*wall,         base_h+2*wall,         base_d],
                        [0,                     base_h+2*wall,         base_d],
                        [bx,                    by,                    total_d],
                        [bx+diffuse_w+2*wall,   by,                    total_d],
                        [bx+diffuse_w+2*wall,   by+diffuse_h+2*wall,   total_d],
                        [bx,                    by+diffuse_h+2*wall,   total_d]],
                       [[0,1,2,3], [4,5,1,0], [7,6,5,4],
                        [5,6,2,1], [6,7,3,2], [7,4,0,3]]);
            translate([wall, wall, -fudge])
            polyhedron([[0,             0,              base_d],
                        [base_w,        0,              base_d],
                        [base_w,        base_h,         base_d],
                        [0,             base_h,         base_d],
                        [bx,            by,             total_d+2*fudge],
                        [bx+diffuse_w,  by,             total_d+2*fudge],
                        [bx+diffuse_w,  by+diffuse_h,   total_d+2*fudge],
                        [bx,            by+diffuse_h,   total_d+2*fudge]],
                       [[0,1,2,3], [4,5,1,0], [7,6,5,4],
                        [5,6,2,1], [6,7,3,2], [7,4,0,3]]);
        }
        // initial diffuser
        translate([0, base_h+2*wall, base_d]) rotate([0, 0, -90]) {
            difference() {
                rect_cone(base_h+2*wall, base_w+2*wall);
                translate([0.5*wall, 0.5*wall, -0.01]) rect_cone(base_h+wall, base_w+wall);
            }
        }
    }
}

// sliced in half for debugging
//difference() {
//diffuser();
//translate([0.5*base_w, -20, -0.01]) cube(100);
//}

diffuser();

