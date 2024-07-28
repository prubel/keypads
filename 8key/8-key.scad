$fn=50;
// distance between wells
wellSpacing = 6;

roundR = 1.5;

keySide = 14;

// the depth of the top "key holder"
baseDepth = 1;
topToLip = 4;

rows=2;
cols=4;

// wall depth for base
wall = 1.5;
// heigth of base
bottomH = 23;

baseW = wellSpacing + cols * (wellSpacing+keySide);
baseH = wellSpacing + rows * (wellSpacing+keySide);
module switchHole() {
 cube ([keySide, keySide, keySide]);
}

module kBase() {
    cube([
        baseW, 
        baseH,
        baseDepth
    ]);
}

module screwTab() {
   cylinder(h=baseDepth, d=7);
}

module screwHole() {
    cylinder(h=baseDepth, d=3);
}


lip = 8;
offS = 1;
// rounded top 
module rTop() {
        hull() {
            difference() {
                union() {
                    // round out the edge
                    translate([offS,offS,3]) rotate([0,0, -45]) scale([0.7,1])sphere(5);
                    translate([baseW-offS, offS, 3]) rotate([0,0, 45]) scale([0.7,1])sphere(5);
                    translate([baseW-offS,baseH-offS, ,3]) rotate([0,0, -45]) scale([0.7,1])sphere(5);
                    translate([offS, baseH-offS,3]) rotate([0,0, 45]) scale([0.7,1])sphere(5);
                    
                        // one set of parallel tubes
                    rotate(a=[-90,0,0]) {
                        translate([2, 0, 2]) {
                            linear_extrude(height=baseH-4, center=false) {
                                scale([0.5, 1]) circle(lip);
                            } 
                        }
                        translate([baseW-2, 0, 2]) {
                            linear_extrude(height=baseH-4, center=false) {
                                scale([0.5, 1]) circle(lip);
                            } 
                        }
                    }
                    
                    
                    // other set of parallel tubes
                    rotate(a=[0,90,0]) {
                        translate([0, 2, 2]) {
                            linear_extrude(height=baseW-4, center=false) {
                                scale([1, 0.5]) circle(lip);
                            } 
                        }
                        translate([0, baseH-2, 2]) {
                            linear_extrude(height=baseW-4, center=false) {
                                scale([1, 0.5]) circle(lip);
                            } 
                        }
                    }   
                } // end union
                // chop off the bottom
                translate([-0.25*baseW, -0.25*baseH,3-bottomH]) {
                    cube([1.5*baseW,1.5*baseH,bottomH]);
                }
            } //difference
        } //hull
    
    
}

// cubes laid on in the correct grid, used in a difference to make 
// space for the switches
module wells() {
    for (i = [1:1:rows]) {
        yoff = wellSpacing + ((i-1) * (wellSpacing+keySide));
        for (j = [1:1:cols]) {
            xoff = wellSpacing + ((j-1) * (wellSpacing + keySide));
            translate([xoff, yoff, 0]) {
                switchHole();
            }
        }
    }
}

// create the grid to hold the switches
module top() {
    difference() {
        union() {
            rTop();
            translate([0.5,0.5,0]) color([1,0,1])cube([baseW-0.5, baseH-0.5, topToLip-1]);
        }
        // cut into the rounding, but not all the way to the bottom
        //translate([2*wall, 2*wall, baseDepth]) {
        translate([2*wall, 2*wall, 2]) {
            cube([baseW-4*wall, baseH-4*wall, bottomH]);
        }
        translate([0, 0, -3]) {
            color([0.25,0.25,0]) wells();
        }
    }    
    
}


// studs and holes for scres or posts thatwill hold a pico pi
module picoSupport() {
    h = 8;
    union() {
        color([0,1,0]) {
            difference (){
                cube([10, 15, h]); //base-front
                translate([3,1.5,0]) {
                    translate([0, 0, 0]) cylinder(h=10, d=2);
                    translate([0, 11.5, 0]) cylinder(h=10, d=2);
                }
            }
            translate([45,0,0]) cube([14, 15, h]); //base-back
            translate([50,1.5,h]) {
                translate([0, 0, 0]) cylinder(h=5, d=2);
                translate([0, 11.5, 0]) cylinder(h=5, d=2);
                translate([3,1,0])  cube([5,10,5]); //backstop
            }
        }
    }
}

// create a box without sharp edges, the main portion of bottom
module rounded_box(x, y, z, radius){
    hull(){
        for (i = [0, x]) {
            for (j = [0, y]) {
                translate([i, j, 0]) {
                    cylinder(r=radius, h=z);
                }
            }
        }
    }
}

// the base of main
module bottom() {
    color([1,0,0]) {
            difference () {
                rounded_box(baseW+2*wall, baseH+2*wall, bottomH, roundR);
                //cube([baseW+2*wall, baseH+2*wall, bottomH]);
                
                //center all inside lip
                translate([wall+2,wall+2, wall]) {
                    cube([baseW-topToLip, baseH-topToLip, bottomH]);
                }
                // twice for a lip:
                // below the lip
                translate([wall,wall, wall]) {
                    cube([baseW, baseH, bottomH]);
                }
            }
        }
        // support studs
    }    


// Create the bottom container, on which the top() will be placed
module main() {
    debug = false;
    difference() {
            difference() {
                bottom();
                // make a hole for the usb plub
                translate([-10, wall+13, 5*wall]) {
                    cube([13, 19, 10]);
                }
            }        
    }
    
    translate([2.5-wall, 15+wall, 0]) {
        picoSupport();
    }
}

//difference() { 
//main();
    //translate([-5,-5,-5]) cube([100,60,23]);
//}
translate([0, 70, 0]) {
    top();
}

