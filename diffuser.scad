base_w = 50; // width of collar, mm
base_h = 40; // height of collar, mm
base_d = 20;
diffuse_w = 80;
diffuse_h = 64;
diffuse_d = 30;
diffuse_rad = 300;
w_diff = (diffuse_w-base_w);
h_diff = (diffuse_h-base_h);
total_d = base_d + diffuse_d;
bx = -0.5*w_diff;
by = -0.5*h_diff;
wall = 1;
fudge = 0.01;

union() {
    difference() {
        cube([base_w+2*wall, base_h+2*wall, base_d]);
        translate([wall, wall, -fudge])
            cube([base_w, base_h, base_d+2*fudge]);
    }
    //translate([-(diffuse_w-base_w)/2, -(diffuse_h-base_h)/2, base_d])
    //    cube([diffuse_w, diffuse_h, diffuse_d]);
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

}
