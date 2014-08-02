// Enter paramaters, view for accuracy in open and closed mode,
// then use print mode for positioning for print.

// ********** //
// Parameters //
// ********** //

// Measured dimensions of wood used for attaching to guide plates.
woodDimensions = ([140,140,20]);
// Measure thickness of bolts used for pivot joints
jointBoltThickness = 8; 
// Rod Positions x, y and measured diameter, length
rods = [
    [40, 96, 6, 320],
    [103, 96, 9.25, 320],
    [23, 44, 8, 320],
    [117,44, 8, 320]
];   

// Plastic plate part, not including guidepost height.
guidePlateThickness = 5; 

guidePostHeight = 50;

assemblyThickness = woodDimensions[2] + guidePlateThickness + guidePostHeight;

// Test Can Height and diameter
canSize = ([170, 33]);

// ************* //
// View or Print //
// ************* //

// print ();
viewOpen ();

module print () {
    mirror ([1,0,0])
    plateAssembly ();
    translate ([4, 0, 0])
    plateAssembly ();
    rodsPositioned();
}

module viewOpen () {
    // Bottom Assembly and Can
    translate ([woodDimensions[0]/2,woodDimensions[1]/2,woodDimensions[2]])
    can();
    translate ([0, 0, woodDimensions[2] + canSize[0]])
    plateAssembly ();
    mirror ([0,0,1])
    plateAssembly ();
}

module viewClosed () {
    mirror ([0,0,1])
    plateAssembly ();
    translate ([0, 0, 170])
    plateAssembly ();
}

module plateAssembly () {
    difference() {
    union () {
        color("red")
        guidePlate ();
        translate([0,0,-20])
        woodBlock(140, 140, 20);
    }

     // Holes through assembly
    union() {
        translate([40, 96, -5])
        cylinder(80, 3, 3);
        translate([103, 96, -5])
        cylinder(140, 9.25 / 2, 9.25 / 2);
        translate([23, 77 - 33, -5])
        cylinder(140, 4, 4);
        translate([140 - 23, 77 - 33, -5])
        cylinder(140, 4, 4);
    }
}
}

module guidePlate ()
{
    difference() {

    // Block and solid cones
    union() {
        cube([140, 140, 10]);

        for (rod=rods)
        translate([40, 96, 0])
        {
            rodGuide(50, 8, 3);
        }
        translate([103, 96, 0])
        {
            rodGuide(50, 8, 9.25 / 2);

        }
        translate([23, 70 - 33 + 7, 0])
        {
            rodGuide(50);
        }
        translate([140 - 23, 70 - 33 + 7, 0])
        {
            rodGuide(50);
        }
    }

}
}

module woodBlock(x, y, z) {
    difference () {
        color ("BurlyWood")
        cube([x, y, z]);
        
    }
}

// Cylinder Guide (Height, Outer Radius, Inner Radius)
module rodGuide (height,or=8,ir=4) {
    difference () {
        cylinder(height,or,or);
        translate([0, 0, -2])
        cylinder(height + 4,ir,ir); // Hole through Cylinder
    }
        supportTriangles ([0, 90, 180, 270],height, height/4,or/3,or-0.5);
}

rodsPositioned(rods);
module rodsPositioned (rods) {
    color ("LightCyan")
    for (rod=rods)
    translate ([rod[0], rod[1], -(assemblyThickness - woodDimensions[2]) ])
    cylinder(rod[3], rod[2]/2, rod[2]/2, $fs=0.1);
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
module can(height=170, diameter=33) {
 color ("LightSlateGray") 
 cylinder(height, diameter, diameter);
}

// Nice safe edges on everything.
module roundoverCube (h, w, d) {
    union () {
        for (r=[0, 90, 180, 270])
        rotate ([r, 0, 0]) 
            fillet(z/2, y);
    }
}

module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}