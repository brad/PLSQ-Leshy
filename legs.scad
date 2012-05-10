include <plsq.scad>
include <chassis.scad>

/**
 * Legs component of the quadcopter.
 *
 * @id plsq-legs
 * @name PLSQ Legs
 * @category Printed
 * @param bool camera Whether on not to make a place to mount the camera.
 * @param bool rafts Whether or not to make the rafts on the corners.
 */
module legs(camera = false, rafts = true) {
	// Middle strips
	if(camera) {
		translate([-ch_full_l / 2 + ch_90_th,
		         l_camera_strip_offset, 0]) {
			cube([ch_full_l - 2 * ch_90_th,
			    l_camera_thin_th, ch_full_h]);
		}
		translate([-(ch_full_l * l_camera_thick_ratio) / 2,
		         l_camera_strip_offset + l_camera_thin_th, 0]) {
			cube([ch_full_l * l_camera_thick_ratio, l_camera_thick_th,
			    ch_full_h]);
		}
		assign(adj = cos(45) * ch_45_th)
		assign(c = ch_45_l - 2 * ((ch_90_th - adj) / cos(45)))
		assign(corner_l = cos(45) * c)
		for(i = [0 : 1]) {
			assign(sign = (i == 1 ? -1 : 1))
			difference() {
				translate([(-ch_full_l / 2 + ch_90_th) * sign -
				         (i == 1 ? corner_l : 0),
					     ch_short_l / 2 - (2 * adj - ch_90_th), 0]) {
					cube([corner_l, corner_l, ch_full_h]);
				}
				translate([-sign * ch_full_l / 2, ch_short_l / 2, 0])
				rotate([0, 0, i == 0 ? 45 : -45]) 
				translate([i == 1 ? -ch_45_l : 0, 0, 0]) {
					cube([ch_45_l, ch_90_th, ch_full_h]);
				}
			}
		}
	}
	else {
		translate([-ch_full_l / 2 + ch_90_th,
			     -(l_strip_ratio / 2) * ch_short_l, 0]) {
			cube([ch_full_l - 2 * ch_90_th,
				l_strip_ratio * ch_short_l, ch_full_h]);
		}
	}

	chassis(rafts) {
		// TODO: Parameterize this better
		assign(half_th = l_leg_th / 2 + (debug ? 0.1 : 0))
		assign(full_th = l_leg_th + (debug ? 0.2 : 0))
		assign(l_l = 60)
		assign(sign = (camera ? -1 : 1)) {
			// Leg
			difference() {
				translate([-40.5, l_leg_th / 2, 40])
				rotate([0, camera ? -24.5 : -24, 0])
				scale([1, 1, camera ? 1.475 : 1.45])
				rotate([90, 0, 0]) {
					cylinder(h = l_leg_th, r = 50, $fn = 50);
				}
				translate([camera ? -29 : -31, half_th, camera ? 56 : 55])
				rotate([0, camera ? -42 : -52.1, 0])
				scale([1, 1, 1.45])
				rotate([90, 0, 0]) {
					cylinder(h = full_th, r = 50, $fn = 50);
				}
				translate([-90, -half_th, -50]) {
					cube([110, full_th, 50]);
				}
				translate([-100, -half_th, camera ? l_cam_h : l_h]) {
					cube([20, full_th, 20]);
				}
				translate([-ch_45_diag + ch_45_l / 2 + (camera ? 0 : ch_45_th),
					     -half_th, debug ? -0.1 : 0]) {
					cube([20, full_th, (camera ? 2 : 1) * ch_full_h + 1]);
				}
			}

			// Taper
			if(camera) {
				assign(taper_h = 7.75)
				hull() {
					translate([-ch_45_diag + ch_45_l / 2, -half_th, 0]) {
						cube([0.01, full_th, taper_h]);
					}
					translate([-ch_45_diag + ch_45_l / 2 + ch_45_th - 0.01,
					         -3 * half_th, 0]) {						
						cube([0.01, 3 * full_th, ch_full_h]);
					}
				}
			}
		}
	}
}

