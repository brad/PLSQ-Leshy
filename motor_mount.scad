include <plsq.scad>

/**
 * Piece to mount a single motor to an arm
 *
 * @id plsq-motor-mount
 * @name PLSQ Motor Mount
 * @category Printed
 * @using 4 m3washer
 * @using 4 m3x10
 * @using brushless-motor
 * @param bool raft Whether or not to make a raft
 */
module motor_mount(raft = true) {
	assign(both_pad = mm_open_pad1 + mm_open_pad2)
	assign(conn_l = mm_arm_l - mm_open_l - both_pad)
	assign(center_offset = tolerance + 0.05)
	assign(negx = mm_open_pad2 - 0.1)
	translate([0, 1.175, 0])
	rotate([0, 0, 2]) {
		if(raft) {
			translate([-mm_arm_half1 - mm_raft_r + 0.2,
			         -mm_arm_runner / 2, 0]) {
				cylinder(h = th, r = mm_raft_r);
			}
		}

		difference() {
			union() {
				// Motor mount arm
				translate([-mm_arm_half1, -mm_arm_runner, 0]) {
					cube([mm_arm_l, mm_arm_runner,
					    a_tall_th + mm_arm_th / 2]);
					translate([0, mm_arm_runner / 2, mm_arm_short_r +
					         a_tall_th + center_offset])
					rotate([0, 90, 0]) {
						difference() {
							union() {
								cylinder(h = conn_l + 0.1, r = mm_arm_short_r);
								translate([center_offset, 0, conn_l]) {
									cylinder(h = mm_open_l + both_pad,
											r = mm_arm_tall_r);
								}
							}
							translate([0, 0, -0.1]) {
								cylinder(h = mm_arm_l - mm_open_l -
								        mm_open_pad2 + 0.2,
								        r = mm_arm_short_r - mm_arm_th);
							}
							translate([mm_arm_short_r + a_tall_th + 
									 center_offset, -mm_arm_runner / 2, 0]) {
								cube([1, mm_arm_runner, mm_arm_l + 0.1]);
							}
							translate([-mm_arm_tall_r, -mm_arm_tall_r,
									 conn_l + mm_open_pad1]) {
								cube([mm_arm_tall_r, 2 * mm_arm_tall_r,
									mm_open_l]);
							}
						}
					}
				}

				// Motor mount cup
				translate([-mm_arm_half1 + mm_arm_l - negx + mm_cup_r1,
						 -mm_arm_runner / 2, 0]) {
					difference() {
						hull() {
							translate([0, 0, mm_cup_base_h]) {
								cylinder(h = mm_cup_h1, r = mm_cup_r1);
							}
							cylinder(h = mm_cup_h2, r1 = mm_cup_r2, r2 = mm_cup_r3);
						}
						// Depression
						translate([0, 0, mm_cup_base_h - mm_cup_dep_h]) {
							cylinder(h = mm_cup_dep_h + 0.1, r1 = mm_cup_dep_r1,
							        r2 = mm_cup_dep_r2, $fn = 30);
						}
						// Holes
						for(i = [45 : 90 : 360 - 45]) {
							translate([-0.08, 0, 0])
							rotate([0, 0, i])
							assign(factor = (i == 45 || i == 225 ? 1.15 : 1.01))
							translate([factor * mm_cup_r2 / 2, 0, -0.1]) {
								hull() {
									cylinder(h = mm_cup_hole_h1 + 0.1,
									        r = mm_cup_hole_r1, $fn = 30);
									translate([0, 0, mm_cup_base_h -
									         2 * mm_cup_hole_h2]) {
										cylinder(h = mm_cup_hole_h2,
										        r = mm_cup_hole_r2, $fn = 30);
									}
								}
								translate([0, 0, mm_cup_base_h -
								         mm_cup_hole_h2]) {
									cylinder(h = mm_cup_hole_h2 + 0.2,
									        r = mm_cup_hole_r2, $fn = 30);
								}
							}
						}
					}
				}
			}

			// Some global differences
			assign(extra = 2)
			assign(diff = 1.4)
			assign(r1 = mm_arm_short_r - mm_arm_th + diff)
			translate([-mm_arm_half1, -mm_arm_runner, 0])
			translate([0, mm_arm_runner / 2, mm_arm_short_r + a_tall_th +
					 center_offset])
			rotate([0, 90, 0])
			translate([center_offset, 0, conn_l + mm_open_pad1]) {
				difference() {
					cylinder(h = mm_open_l + mm_open_pad2 + extra, r = r1);

					// Ramp into the cup, not the best solution, but w/e
					translate([0, 0, mm_open_l]) {
						// I <3 hull
						hull() {
							translate([0.3, 0, 0])
							difference() {
								translate([0.05, 0, 0]) {
									cylinder(h = 0.01, r = r1);
								}
								scale([1, 1.1, 1])
								translate([0, 0, -0.1]) {
									cylinder(h = 0.21, r = r1);
								}
							}
							assign(r2 = mm_cup_r2 - mm_cup_th + 2)
							difference() {
								translate([0, 0, mm_open_pad2]) {
									cylinder(h = extra, r = (2 * r1 > r2) ? 
									        (r2 / 2) : r1, $fn = 100);
								}
								rotate([0, -90, 0]) {
									translate([mm_cup_r1, 0, -mm_arm_short_r -
									         a_tall_th + mm_cup_base_h]) {
										cylinder(h = mm_cup_h2 -
										        mm_cup_base_h + 0.1,
												 r = r2);
									}
								}
							}
						}
					}
				}
			}
			translate([-mm_arm_half1 + mm_arm_l - negx + mm_cup_r1,
					 -mm_arm_runner / 2, 0])
			translate([0, 0, mm_cup_base_h]) {
				cylinder(h = mm_cup_h2 - mm_cup_base_h + 0.1,
						r = mm_cup_r2 - mm_cup_th);
			}
		}
	}
}
