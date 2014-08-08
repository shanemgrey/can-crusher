// Used to make a fillet on an inside edge, and radius over an outside edge

// dia = 9.6;
// rad = 4.8;
// length = 100;

// Diameter of the fillet, radius of the roundover, length of the surface
// rotate (a=[90,0,0])
 //filletRadius (9.6, 9.6/2, 100);
module filletRadius (dia, rad, length) {
  union () {
    
    // Quarter Taurus
    intersection () {
      rotate_extrude(convexity = 4, $fn = 20)
      translate([rad+dia/2, 0, 0])
      hull () {
        translate ([0,-dia/2,0])
        circle(r = (dia)/2, $fn = 20);
        translate ([0,dia/2,0])
        circle(r = (dia)/2, $fn = 20);
      }
      translate ([0,0,-dia])
      cube (dia*2);
    }

    // Cylinders Hulled
    rotate (a=[90,180,270])
    hull() {
      translate ([rad+dia/2,dia/2,-0.5])
        cylinder(h=length-rad*2+1,r=dia/2);
      translate ([rad+dia/2,-dia/2,-0.5])
        cylinder(h=length-rad*2+1,r=dia/2);
    }
    
    // Other Quarter Taurus
    translate ([-(length-rad*2),0,0]) 
    mirror (){
    intersection () {
      rotate_extrude(convexity = 4, $fn = 20)
      translate([rad+dia/2, 0, 0])
      hull () {
        translate ([0,-dia/2,0])
        circle(r = (dia)/2, $fn = 20);
        translate ([0,dia/2,0])
        circle(r = (dia)/2, $fn = 20);
      }
      translate ([0,0,-dia])
      cube (dia*2);
      }
    }

  }
}

// Use these to line up the cut
// color("blue")
// hull() {
//   translate ([0,dia/2,0])
//     sphere(r=dia/2, $fn = 30);
//   translate ([0,-dia/2,0])
//     sphere(r=dia/2, $fn = 30);
// }
//color("green")
//cube(dia, center=true);