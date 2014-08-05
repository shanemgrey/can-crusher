// Enter paramaters, view for accuracy in open and closed mode,
// then use print mode for positioning for print.

// ********** //
// Parameters //
// ********** //

// Measured dimensions of wood used for attaching to guide plates.
woodDimensions = [100, 100, 20];

// Measure thickness of bolts used for pivot joints
jointBoltThickness = 8; 

// Plastic plate part, not including guidepost height.
guidePlateThickness = 5; 

guidePostHeight = 40;

assemblyThickness = woodDimensions[2] + guidePlateThickness + guidePostHeight;

// Can Height and radius
// canSize = [122.7, 33.1];  // 12 oz
canSize = [157.2, 33.1];  // 16 oz

rodThicknesses = [9.6, 9.6, 9.6, 9.6];
rodLengths = [320, 320, 320, 320];
// Rod Positions x, y and measured radius, length
rods = [
    [12.1, (woodDimensions[0]-canSize[1]*2)/2, rodThicknesses[0], rodLengths[0]],
    [87.9, (woodDimensions[0]-canSize[1]*2)/2, rodThicknesses[1], rodLengths[1]],
    [79.5, woodDimensions[0]-((woodDimensions[0]-canSize[1]*2)/2), rodThicknesses[1], rodLengths[1]],
    [20.5, woodDimensions[0]-((woodDimensions[0]-canSize[1]*2)/2), rodThicknesses[0], rodLengths[0]],
];  

// ************* //
// View or Print //
// ************* //

// print ();
viewOpen ();
// viewClosed ();

module print () {
    mirror ([1,0,0])
    plateAssembly ();
    translate ([4, 0, 0])
    plateAssembly ();
    rodsPositioned();
}

module viewOpen () {
    // Bottom Assembly and Can
    // translate ([woodDimensions[0]/2,woodDimensions[1]/2,woodDimensions[2]])
    translate ([woodDimensions[0]/2,woodDimensions[1]/2,woodDimensions[2]])
    can(canSize[0],canSize[1], $fn = 100);
    translate ([0, 0, 40 + canSize[0]])
    plateAssembly ();
    mirror ([0,0,1])
    plateAssembly ();
    rodsPositioned(rods);
}

module viewClosed () {
  canSize= ([30, 33.1]);
    translate ([woodDimensions[0]/2,woodDimensions[1]/2,woodDimensions[2]])
    can();
    translate ([0, 0, woodDimensions[2] + canSize[0]])
    plateAssembly ();
    mirror ([0,0,1])
    plateAssembly ();
    rodsPositioned(rods);
}

module plateAssembly () {
  difference() {
    union () {
        color("red")
        guidePlate ();
        translate([0,0,-20])
        woodBlock();
    }
  }
}

module rodsPositioned (rods) {
    color ("LightCyan")
    for (rod=rods)
      translate ([rod[0], rod[1], -(assemblyThickness - woodDimensions[2]) ])
      cylinder(rod[3], rod[2]/2, rod[2]/2, $fn=50);
}

module guidePlate (dim = [woodDimensions[0],woodDimensions[1], guidePlateThickness])
{
  // Block and solid cones
  union() {
      
    union () {
    roundedBox(dim, guidePlateThickness/2, false, $fn = 30);
    roundedBox(dim - [0,0,dim[2]/2], guidePlateThickness/2, true, $fn = 30);
    }

    union() {
      for (rod=rods)
        translate([rod[0], rod[1], guidePlateThickness-1])
        rodGuide (guidePostHeight, rod[2]*1.5/2, rod[2]/2);
    }
  }
}

module woodBlock(dim = woodDimensions) {
  difference () {
    color ("BurlyWood")
    union () {
    roundedBox(dim, 5, false, $fn = 30);
    translate([0, 0, dim[2]/2])
    roundedBox(dim - [0,0,dim[2]/2], 5, true, $fn = 30);
    }

    // Holes through block
    union() {
      for (rod=rods)
        translate([rod[0], rod[1], -5])
        cylinder(dim[2] +10, d=rod[2]);
    }
  }
}


// EXAMPLE USAGE:
// rodGuide (50, 9, 6);
// Rod Guide (Height, Outer Radius, Inner Radius)
module rodGuide (height,or,ir) {
      union () {
        cylinder(height-(or/2),or*1.5,or, $fn = 100);
        translate ([0,0,height-or/2])
        rotate_extrude(convexity = 10, $fn = 100)
        translate([or-(or-ir)/2, 0, 0])
        circle(r = (or-ir)/2, $fn = 50);
      }
      //supportTriangles ([0, 90, 180, 270],height-or/2, height/4,or/3,or-0.5);
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


// EXAMPLE USAGE:
// !can(height=122.7, radius=33);

// Can to be crushed.
module can(height, radius) {
    color ("LightSlateGray") 
    union (){
        translate([0, 0, radius*.25])
        cylinder(height-radius*.5, r=radius);
        
        // Round over top
        rotate_extrude(convexity = 10)
        translate([radius*.75, height-radius*.25, 0])
        circle(radius/4, $fn = 30);
        
        // Round over Bottom
        rotate_extrude(convexity = 10)
        translate([radius*.75,radius*.25, 0])
        circle(radius/4, $fn = 30);
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