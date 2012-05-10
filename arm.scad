include <plsq.scad>

/**
 * PLSQ Arm
 *
 * By default, this makes the whole thing. For printers
 * that don't have sufficient z-height, the arm can be
 * split into halves that can be glued together after
 * printing.
 *
 * @id plsq-arm
 * @name PLSQ Arm
 * @category Printed
 * @param bool split Whether or not to split the arm in half
 * @param int half Which half to print. 1 = first, 2 = second
 * @param bool raft Whether or not to make a raft
 * @param bool coupler When true, connect the halves with a coupler
 */
module arm(split = false, half = -1, raft = true, coupler = false) {
	for(i = [((split && half == 2) ? 1 : 0) :
	         ((split && half != 1) ? 1 : 0)]) {
		assign(a_tall_h = (split && i == 0) ? 
		      (coupler ? (a_tall_h / 2) :
		      (a_tall_h / 2 + a_overlap)) : a_tall_h)
		assign(a_tall_h = (split && i == 1) ?
		      a_tall_h / 2  : a_tall_h) {
			if(raft) {
				cylinder(h = th, r = a_raft_r);
			}
			difference() {
				union() {
					if( ! (split && i ==1)) {
						cylinder(h = a_short_h + th, r = a_short_r);
					}
					cylinder(h = th + a_tall_h, r = a_tall_r);
				}
				translate([0, 0, th]) {
					translate([0, 0, -th]) {
						cylinder(h = a_tall_h + th + 0.1, r = a_tall_r -
						        a_tall_th);
					}
					rotate([0, 0, 45]) {
						translate([0, -a_slot_w / 2, 0]) {
							translate([0, 0, -th]) {
								cube([a_short_r + 0.1, a_slot_w,
								    ((split && i == 1) ? a_slot_upper_h : 
								    a_slot_lower_h) + th]);
							}
							if( ! split) {
								translate([0, 0, a_tall_h - 
								         a_slot_upper_h]) {
									cube([a_short_r + 0.1, 
									     a_slot_w,
									     a_slot_upper_h + 0.1]);
								}
							}
							else if(i == 0 && ! coupler) {
								translate([0, a_slot_w / 2, a_tall_h -
								         a_overlap])
								rotate([0, 0, -45]) {
									difference() {
										cylinder(h = a_overlap,
										        r = a_tall_r + 0.1);
										cylinder(h = a_overlap,
										        r = a_tall_r - a_tall_th / 2 -
										        tolerance / 2);
									}
								}
							}
							else if(i == 1 && ! coupler) {
								translate([0, a_slot_w / 2, a_tall_h -
								         a_overlap]) {
									cylinder(h = a_overlap,
									        r = a_tall_r - a_tall_th / 2 -
									        tolerance / 2);
								}
							}
							else if(coupler) {
								translate([0, 0, a_tall_h - 
								         a_coupler_h / 2]) {
									cube([a_tall_r, a_slot_w,
									    a_coupler_h / 2 + 0.1]);
								}
							}
						}
					}
				}
			}
		}
	}
}

/**
 * A full arm, split in half
 *
 * @param bool coupler Whether to connect the halves
 *     with a coupler instead of directly.
 * @param bool raft Whether to make a raft
 */
module split_arm(coupler = false, raft = true) {
	for(i = [1 : 2]) {
		translate([i == 1 ? 0 : (2 * a_short_r + 1), 0, 0]) {
			arm(split = true, half = i, raft = raft, coupler = coupler);
		}
	}
	if(coupler) {
		translate([a_short_r + 0.5, 2 * a_short_r, 0]) {
			difference() {
				cylinder(h = a_coupler_h, r = a_tall_r +
						a_tall_th + tolerance);
				translate([0, 0, -0.1]) {
					cylinder(h = a_coupler_h + 0.2,
							r = a_tall_r + tolerance);
				}
			}
			rotate([0, 0, 45]) {
				translate([a_tall_r / 2, -a_slot_w / 2, 0]) {
					cube([a_tall_r / 2 + a_tall_th / 2, a_slot_w - 
						2 * tolerance, a_coupler_h]);
				}
			}
		}
	}
}
