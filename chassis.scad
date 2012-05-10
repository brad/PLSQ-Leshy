include <plsq.scad>

/**
 * PLSQ inner frame
 *
 * The child of this module will be made at each corner. Ex:
 *
 * chassis()
 * union() {
 *     // Stuff at corners
 *     ...
 * }
 *
 * @param rafts Wether or not to make rafts at the corners
 */
module chassis(rafts = true) {
	for(i = [0 : 45 : 360 - 45]) {
		rotate([0, 0, i]) {
			if(i % 90 == 0) {
				translate([-ch_short_l / 2, -ch_full_l / 2, 0]) {
					difference() {
						cube([ch_short_l, ch_90_th, ch_full_h]);

						// Cutouts
						for(j = [0 : 1]) {
							translate([j == 0 ? (ch_cutout_ratio * ch_short_l) :
							         ((1 - ch_cutout_ratio) * ch_short_l -
							         ch_cutout_w),
							         debug ? -0.1 : 0, debug ? -0.1 : 0])
							difference() {
								cube([ch_cutout_w,
								    ch_90_th + (debug ? 0.2 : 0),
								    ch_full_h + (debug ? 0.2 : 0)]);
								translate([debug ? -0.1 : 0, ch_cutout_front_th,
								         debug ? -0.1 : 0]) {
									cube([ch_cutout_w + (debug ? 0.2 : 0),
									    ch_90_th - ch_cutout_front_th -
									    ch_cutout_back_th,
									    ch_full_h - ch_cutout_th]);
								}
							}
						}
					}
				}
			}
			else { // i % 45 == 0
				translate([0, -ch_45_diag + ch_45_l / 2, 0]) {
					translate([-ch_45_l / 2, 0, 0]) {
						cube([ch_45_l, ch_45_th, ch_full_h]);
					}
					if(rafts) {
						translate([0, -l_leg_l - l_raft_r + 0.2, 0]) {
							cylinder(h = th, r = l_raft_r);
						}
					}
				}

				child();
			}
		}
	}
}

