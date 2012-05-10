include <plsq.scad>
include <ArchitectsDaughter.scad>

c_bottom_short_l = c_bottom_l - 2 * (cos(45) * c_45_l);
c_w_receiver_l = 2 * cos(45) * c_bottom_short_l + c_45_l;
c_w_receiver_factor = c_w_receiver_l / c_bottom_l;    // w/receiver
c_wo_receiver_factor = (1.015 * c_w_receiver_l) / c_bottom_l;  // w/o receiver

/**
 * PLSQ canopy
 *
 * @id plsq-canopy
 * @name PLSQ Canopy
 * @category Printed
 * @using more-fontz
 * @param bool receiver Set to true to make a bay for the receiver
 * @param bool upside_down Set to true to render upside down
 * @param bool text Display name on the canopy
 */
module canopy(receiver = false, upside_down = false, text = true) {
	assign(xyfactor = (c_bottom_l - 2 * c_th) / c_bottom_l)
	assign(zfactor = (c_bottom_h + c_top_h - c_th) / 
	      (c_bottom_h + c_top_h))
	translate([0, 0, upside_down ? (c_bottom_h + c_top_h) : 0])
	rotate([upside_down ? 180 : 0, 0, 0])
	translate([-0.04, receiver ? 6 : 0, 0]) {
		difference() {
			// Hull
			canopy_hull(receiver);
			translate([0, 0, debug ? -0.02 : 0])
			scale([xyfactor, xyfactor, zfactor]) {
				canopy_hull(receiver);
			}

			// Text
			if(text) {
				assign(angle = atan(c_top_h / ((c_middle_l - c_top_l) / 2)))
				assign(factor = c_top_l / ArchitectsDaughter_width(c_text))
				assign(c = c_top_h / cos(angle))
				translate([0, c_bottom_l / 2, c_bottom_h + 6])
				rotate([-angle, 0, 0])
				rotate([0, 0, 180])
				translate([0, c / 3, c_th > 2 ? -1 : -(c_th / 2)])
				scale([factor, factor]) {
					ArchitectsDaughter(c_text, center = true);
				}
			}

			// Windows
			for(i = [0 : 1]) {
				assign(x = sqrt(2 * pow(c_bottom_l, 2)))
				rotate([0, 0, 45 + i * 90])
				translate([-x / 2, 0, 0.77]) {
					translate([0, -c_window_w / 2, 0]) {
						cube([x, c_window_w, c_window_h - c_window_w / 2]);
					}
					translate([0, 0, c_window_h - c_window_w / 2])
					rotate([0, 90, 0]) {
						cylinder(h = x, r = c_window_w / 2);
					}
				}
			}

			if( ! upside_down) {
				// Cutout to improve bridging
				assign(x = xyfactor * sqrt(2 * pow(c_top_l / 2, 2)))
				rotate([0, 0, 45])
				translate([-x / 2, -x / 2,
				          c_bottom_h + c_top_h - c_th - 
				          (debug ? 0.03 : 0.01)]) {
					cube([x, x, th]);
				}
			}
		}

		// Receiver bin
		if(receiver) {
			difference() {
				receiver_hull();
				translate([c_th, c_th, 0]) {
					receiver_hull(inside = true);
				}
			}
		}
	}
}

/**
 * Helper module to draw the base canopy shape
 *
 * @param bool receiver Whether or not we are adding a receiver bay
 */
module canopy_hull(receiver = false) {
	hull() {
		// Bottom cross section
		linear_extrude(height = 0.1) {
			xsection(c_bottom_l, receiver);
		}
		// Middle cross section
		translate([0, 0, c_bottom_h - 0.1])
		linear_extrude(height = 0.1) {
			xsection(c_middle_l, false);
		}
		// Top cross section
		translate([-c_top_l / 2,
		         -c_top_l / 2, c_bottom_h + c_top_h - 0.1]) {
			cube([c_top_l, c_top_l, 0.1]);
		}
	}
}

/**
 * Helper module to draw a cross-section of the canopy
 *
 * @param float length The length of the cross-section
 * @param bool receiver Whether or not we are adding a receiver bay
 */
module xsection(length, receiver = false) {
	intersection() {
		translate([-length / 2, -length / 2]) {
			square([length, length]);
		}
		// Scale length for rotated square
		scale(receiver ? c_w_receiver_factor : 
		     c_wo_receiver_factor)
		rotate([0, 0, -45])
		translate([-length / 2, -length / 2]) {
			square([length, length]);
		}
	}
}

/**
 * Helper module to draw the receiver bay shape
 *
 * @param bool inside Whether this is the outside or inside shape
 */
module receiver_hull(inside = false) {
	// Scaled length for rotated square
	assign(slength = [
	                 c_w_receiver_factor * c_bottom_l,
	                 c_wo_receiver_factor * c_middle_l
	                 ])
	// Half the length of the main square's diagonal
	assign(clength = [
	                 sqrt(2 * pow(c_bottom_l, 2)) / 2,
	                 sqrt(2 * pow(c_middle_l, 2)) / 2
	                 ])
	// Receiver bin length
	assign(rlength = [c_bottom_l - 
	      2 * sqrt(2 * pow(clength[0] - slength[0] / 2, 2)),
	      c_middle_l - 
	      2 * sqrt(2 * pow(clength[1] - slength[1] / 2, 2))])
	assign(xscale = ((rlength[0] - 2 * c_th) / rlength[0]))
	assign(yscale = ((c_receiver_w - c_th) / c_receiver_w))
	assign(zscale = ((c_bottom_h - 2 * c_th) / c_bottom_h))
	assign(c_receiver_top_h = tan(c_receiver_angle) *
	      c_receiver_w)
	translate([-rlength[0] / 2,
	          -c_bottom_l / 2 - c_receiver_w,
	          debug && inside ? -0.1 : 0])
	scale([inside ? xscale : 1, inside ? yscale : 1,
	      inside ? zscale : 1])
	hull() {
		cube([rlength[0], c_receiver_w, 0.01]);
		// NOTE: The x value of this translate and cube
		// are not right, but they work well enough and I
		// was getting lazy. A fix would be appreciated.
		translate([rlength[0] /2 - rlength[1] / 2, 0,
		          c_bottom_h - c_receiver_top_h - 0.01]) {
			cube([rlength[1], c_receiver_w +
			    c_bottom_l / 2 - c_middle_l / 2, 0.01]);
		}
		translate([rlength[0] /2 - rlength[1] / 2, 
		     		c_receiver_w + c_bottom_l / 2 -
		          c_middle_l / 2, c_bottom_h - 0.01]) {
			cube([rlength[1], 0.01, 0.01]);
		}
	}
}
