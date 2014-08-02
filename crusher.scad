// print ();
view ();

module print () {
    mirror ([1,0,0])
    guidePlate ();
    translate ([4, 0, 0])
    guidePlate ();
}

module view () {
    mirror ([1,0,0])
    guidePlate ();
    translate ([4, 0, 0])
    guidePlate ();
}

module guidePlate ()
{
    difference() {

    // Block and solid cones
    union() {
        cube([140, 140, 10]);
        translate([40, 96, 0])
        {
            cylinderGuide(50, 8, 3);
        }
        translate([103, 96, 0])
        {
            cylinderGuide(50, 8, 9.25 / 2);

        }
        translate([23, 70 - 33 + 7, 0])
        {
            cylinderGuide(50);
        }
        translate([140 - 23, 70 - 33 + 7, 0])
        {
            cylinderGuide(50);
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


// Cylinder Guide (Height, Outer Radius, Inner Radius)
module cylinderGuide (height,or=8,ir=4) {
    difference () {
        cylinder(height,or,or);
        translate([0, 0, -2])
        cylinder(height + 4,ir,ir); // Hole through Cylinder
    }
        supportTriangles ([0, 90, 180, 270],height, height/3,or/4,or-0.5);
}

//  Support Triangle rIn = Duplication at rotated values,ir = translation of x from center of rotation
module supportTriangles (rIn=[0, 90, 180, 270], height, width, thickness,ir ) {
    for (r=rIn)
    rotate ([0, 0, r]) 
    translate([0,ir, 0])
    polyhedron (
        points=[ [-thickness/2,0,0],[thickness/2,0,0],[-thickness/2,width,0],[thickness/2,width,0],[-thickness/2,0,height],[thickness/2,0,height] ],
        faces=[ [0,1,2], [1,2,3], [0,1,4], [1,4,5], [2,3,4], [3,4,5], [0,2,4], [1,3,5] ]
        );
}





// Can to be crushed.
 translate([70, 70, -170])
 color ("red") cylinder(170, 33, 33);
