// Handle Grip

//handleArm (240, 20, 20, 10);
module handleArm (h, w, d, r) {
    union () {
        cube ([h, w, d], true);

        translate ([-h/2, 0, 0])
        cylinder(h=d, r=r, center=true, $fn=20);
        
        translate ([h/2, 0, 0])
            cylinder(h=d, r=r, center=true, $fn=20);
    }
}