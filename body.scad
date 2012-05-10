include <plsq.scad>
include <chassis.scad>

/**
 * PLSQ Body
 *
 * The part where all the guts (and brains) go.
 *
 * @id plsq-body
 * @name PLSQ Body
 * @category Printed
 * @using multiwii-se
 * @param bool rafts Whether to make the rafts
 */
module body(rafts = true) {
	assign(adj = cos(45) * ch_45_th)
	assign(c = ch_45_l - 2 * ((ch_90_th - adj) / cos(45)))
	assign(corner_l = cos(45) * c)
	assign(center_l = b_beam_w + 2 * b_beam_trim)
	assign(th  = 0.16 * ch_45_l)
	assign(side = cos(45) * ch_90_th)
	chassis(rafts = rafts) {
		union() {
			// Arm connectors
			assign(r_th = a_slot_w - 0.5)
			assign(zneg = 0.55) {
				translate([-r_th / 2, -ch_45_diag +
					     ch_45_l / 2 - l_leg_l - 0.2, 0]) {
					cube([r_th, l_leg_l + 0.3, b_h - 2 * b_arm_r -
					    zneg + b_arm_th / 2]);
				}
				translate([0, -ch_45_diag + ch_45_l / 2 - l_leg_l - 0.2,
				         b_h - zneg - b_arm_r])
				rotate([-90, 0, 0])
				difference() {
					cylinder(h = l_leg_l + 0.3, r = b_arm_r);
					translate([0, 0, -0.1]) {
						cylinder(h = l_leg_l, r = b_arm_r - b_arm_th);
					}
				}
			}
			difference() {
				union() {
					// Center cube
					translate([-center_l / 2, -center_l / 2 - 0.1, 0]) {
						cube([center_l, center_l / 2 + 0.2, b_h]);
					}

					// Cross beam
					difference() {
						translate([-ch_45_l / 2, -ch_45_diag + ch_45_l / 2,
						         ch_full_h - 0.1]) {
							cube([ch_45_l, ch_45_diag - ch_45_l / 2 -
							    center_l / 2 + 0.1, b_h - ch_full_h + 0.1]);
						}
						translate([-ch_45_l / 2 - 0.1, -ch_45_diag +
						         ch_45_l / 2 + 2 * side, ch_full_h - 0.2]) {
							cube([ch_45_l + 0.2, ch_45_diag - ch_45_l / 2 - 
							    2 * side - center_l / 2 + 1,
								b_h - b_beam_h - ch_full_h + 0.2]);
						}
					}
					translate([0, -b_beam_cyl_place - b_beam_w / 2, b_h])
					difference() {
						cylinder(h = b_beam_cyl_h, r = b_beam_cyl_r, $fn = 20);
						cylinder(h = b_beam_cyl_h + 0.1, r = b_beam_cyl_r -
						        b_beam_cyl_th, $fn = 20);
					}
				}
				assign(b_h2 = 0.34 * b_h)
				assign(o = (b_h - b_h2))
				assign(a = (ch_45_l / 2 - b_beam_w / 2))
				assign(angle = atan(o / a))
				assign(l = sqrt(pow(o, 2) + pow(a, 2)))
				assign(h = sin(angle) * a)
				for(i = [0 : 1]) {
					assign(sign = (i == 0 ? -1 : 1))
					translate([sign * b_beam_w / 2,
					         -ch_45_diag + ch_45_l / 2 - 0.1, b_h])
					rotate([0, sign * angle, 0]) 
					translate([i == 0 ? -l : 0, 0, 0]) {
						cube([l, ch_45_diag - ch_45_l / 2 -
						    b_beam_w / 2 + 0.1, h]);
					}
					assign(sign = (i == 0 ? -1 : 1))
					translate([i == 0 ? (-ch_45_l / 2) : (b_beam_w / 2 +
					         b_beam_trim), -ch_45_diag + ch_45_l / 2 + 2 *
					         side, ch_full_h]) {
						cube([(ch_45_l - b_beam_w) / 2 -
						    (i == 0 ? b_beam_trim : 0), ch_45_diag -
						    ch_45_l / 2 - 2 * side - center_l / 2 + 0.2, 
						    b_h - b_beam_h]);
					}
				}
			}

			// Lower beams
			linear_extrude(height = ch_full_h) {
				difference() {
					hull() {
						translate([-ch_45_l / 2, -ch_45_diag +
						         ch_45_l / 2 + ch_45_th - 0.1]) {
							square([ch_45_l, 2 * side - ch_45_th + 0.1]);
						}
						translate([-center_l / 2, -center_l / 2 - th + 0.1]) {
							square([center_l, th]);
						}
					}
					hull() {
						assign(angle = atan((ch_45_diag - ch_45_l / 2) / 
						      (ch_45_l / 2)))
						assign(factor = 0.95)
						assign(side2 = (factor * side) / tan(angle))
						translate([-ch_45_l / 2 + th + side2,
						         -ch_45_diag + ch_45_l / 2 + 2 * side +
						         factor * side]) {
							square([ch_45_l - 2 * (th + side2), 0.01]);
						}
						translate([-center_l / 2 + th,
						         -center_l / 2 - 2 * th]) {
							square([center_l - 2 * th, th]);
						}
					}
				}
			}
		}
	}
}
