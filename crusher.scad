// print ();
view ();

module part ()
{
    difference() {

    // Block and solid cones
    union() {
        cube([140, 140, 10]);
        translate([40, 96, 0])
        {
            cylinder(50, 7, 7);
            support ();
        }
        translate([103, 96, 0])
        {
            cylinder(50, 8, 8);
            support ();
        }
        translate([23, 70 - 33 + 7, 0])
        {
            cylinder(50, 7, 7);
            support ();

        }
        translate([140 - 23, 70 - 33 + 7, 0])
        {
            cylinder(50, 7, 7);
            support ();
        }
    }

    // Holes through cones
    union() {
        translate([40, 96, -5])
        cylinder(90, 3, 3);
        translate([103, 96, -5])
        cylinder(90, 9.25 / 2, 9.25 / 2);
        translate([23, 77 - 33, -5])
        cylinder(90, 4, 4);
        translate([140 - 23, 77 - 33, -5])
        cylinder(90, 4, 4);
    }
}
}

//  Supports
module support (rIn=[0, 90, 180, 270]) {
    for (r=rIn)
    rotate ([0, -90, r]) 
    translate([23, 7, 0])
    polygon(points=[[0,12],[26,0],[0,0]], paths=[[0,1,2]]);

}

module print () {
    mirror ([1,0,0])
    part ();
    translate ([4, 0, 0])
    part ();
}

module view () {
    mirror ([1,0,0])
    part ();
    translate ([4, 0, 0])
    part ();
}



// Can to be crushed.
 translate([70, 70, -170])
 color ("red") cylinder(170, 33, 33);
