// Enter paramaters, view for accuracy in open and closed mode,
// then use print mode for positioning for print.

// ********** //
// Parameters //
// ********** //

// Measured dimensions of wood used for attaching to guide plates.
woodDimensions = [140, 140, 20];

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
        woodBlock();
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

module guidePlate (dim = [woodDimensions[0],woodDimensions[1],woodDimensions[2]/2])
{
    difference() {

    // Block and solid cones
    union() {
        
        union () {
        roundedBox(dim, 5, false, $fn = 50);
        roundedBox(dim - [0,0,dim[2]/2], 5, true, $fn = 50);
        }

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

module woodBlock(dim = woodDimensions) {
        color ("BurlyWood")
        union () {
        roundedBox(dim, 5, false, $fn = 50);
        translate([0, 0, dim[2]/2])
        roundedBox(dim - [0,0,dim[2]/2], 5, true, $fn = 50);
        }
}

// !rodGuide (50);

// Cylinder Guide (Height, Outer Radius, Inner Radius)
module rodGuide (height,or=8,ir=4) {
      union () {
        cylinder(height-(or/2),or,or);
        translate ([0,0,height-or/2])
        rotate_extrude(convexity = 10)
        translate([or-(or-ir)/2, 0, 0])
        circle(r = (or-ir)/2, $fn = 100);
      }
      supportTriangles ([0, 90, 180, 270],height-or/2, height/4,or/3,or-0.5);
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
    union (){
        translate([0, 0, 10])
        cylinder(height-20, diameter, diameter);
        
        // Round over top
        rotate_extrude(convexity = 10)
        translate([diameter*.75, 160, 0])
        circle(diameter/4, $fn = 50);
        
        // Round over Bottom
        rotate_extrude(convexity = 10)
        translate([diameter*.75, 10, 0])
        circle(diameter/4, $fn = 50);
    }
}



// EXAMPLE USAGE:
// !roundedBox(woodDimensions, 5, true);

// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly) {
  rot = [ [0,0,0], [90,0,90], [90,90,0] ];

  // Translate shape back to origin on corners
  translate((size - [0,0,0])/2)
  if (sidesonly) {
    cube(size - [2*radius,0,0], true);
    cube(size - [0,2*radius,0], true);
     // Full length cylinders on 4 edges
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2]) {
      translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
    }
  }
  else {
    cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);
    // Cylinders shortened and on all cube edges
    for (axis = [0:2]) {
      for (x = [radius-size[axis]/2, -radius+size[axis]/2],
             y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
        rotate(rot[axis]) 
          translate([x,y,0]) 
          cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
      }
    }
    //sphere corners
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2],
           z = [radius-size[2]/2, -radius+size[2]/2]) {
      translate([x,y,z]) sphere(radius);
    }
  }
}