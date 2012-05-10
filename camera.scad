include <plsq.scad>

yneg = -10.5;

/**
 * A mount for a GoPro camera
 *
 * @id plsq-gopro-camera-mount
 * @name PLSQ GoPro Camera Mount
 * @category Printed
 * @type plsq-camera-mount
 */
module gopro_camera_mount() {
	assign(cm_gp_side_w = 5.5)
	assign(cm_gp_bottom_w = 10)
	assign(cm_gp_r1 = 5.5)
	assign(cm_gp_r2 = 9.2)
	assign(cm_gp_yneg = 1.2)
	assign(cm_gp_back_w1 = 21)
	assign(cm_gp_back_w2 = 11.5)
	assign(cm_gp_back_h2 = 18.5)
	camera_mount()
	union() {
		// Sides
		translate([-cm_w / 2 - 0.1, yneg + cm_gp_side_w, cm_gp_bottom_w]) {
			difference() {
				cube([cm_w + 0.2, cm_l - 2 * cm_gp_side_w, cm_h -
				    cm_gp_side_w - cm_gp_bottom_w]);
				translate([0, cm_l - 2 * cm_gp_side_w - cm_gp_yneg -
				         cm_gp_r1, -cm_gp_bottom_w]) {
					minkowski() {
						cube([cm_th + 0.2, cm_gp_r1 + cm_gp_yneg + cm_gp_side_w,
						    cm_gp_bottom_w]);
						rotate([0, 90, 0]) {
							cylinder(h = cm_th + 0.2, r = cm_gp_r2, $fn = 30);
						}
					}
				}
			}
			translate([0, cm_l - 2 * cm_gp_side_w - cm_gp_yneg -
			         cm_gp_r1, 0])
			rotate([0, 90, 0]) {
				cylinder(h = cm_th + 0.2, r = cm_gp_r1, $fn = 30);
			}
		}
		// Front
		translate([-cm_w / 2 + cm_gp_side_w, yneg + cm_l - cm_th - 0.1,
		         cm_gp_bottom_w]) {
			cube([cm_w - 2 * cm_gp_side_w, cm_th + 0.2, cm_h -
			    cm_gp_bottom_w + 0.1]);
		}
		// Back
		translate([-camh_w / 2, yneg - 0.1, cm_gp_bottom_w]) {
			cube([cm_gp_back_w1, cm_th + 0.2, cm_h - cm_gp_side_w -
			    cm_gp_bottom_w]);
		}
		translate([camh_w / 2 + 2 * tolerance, yneg - 0.1, cm_gp_bottom_w]) {
			cube([cm_gp_back_w2, cm_th + 0.2, cm_gp_back_h2]);
		}
		// Bottom
		translate([-cm_w / 2 + cm_gp_side_w, yneg + cm_gp_side_w, -0.1]) {
			cube([cm_w - 2 * cm_gp_side_w, cm_l - 2 * cm_gp_side_w,
			    cm_th + 0.2]);
		}
	}
}

/**
 * The shell for the camera mount
 *
 * Specify the dimensions of the camera mount needed to
 * fit your camera (cm\_w, cm\_l, cm\_h) making sure to take
 * in to account the thickness of the mount.
 * Calling this function will create the camera mount
 * shell, then the child will be differenced from it. Ex:
 *     camera\_mount()
 *     union() {
 *         ...
 *     }
 *
 * @id plsq-camera-mount
 * @name PLSQ Camera Mount
 * @category Printed
 */
module camera_mount() {
	assign(zpos = 0.37)
	difference() {
		union() {
			translate([-cm_w / 2, yneg, 0]) {
				cube([cm_w, cm_l, cm_h]);
			}
			for(i = [-1 : 2 : 1]) {
				assign(zpos2 = -0.325)
				difference() {
					hull() {
						translate([i * camh_w / 2 -
						         (i == -1 ? cm_hinge_w : 0) +
						         i * 2 * tolerance,
								  yneg, cm_h + zpos - cm_hinge_h]) {
							cube([cm_hinge_w, cm_th, cm_hinge_h]);
							translate([0, -cm_hinge_off - cm_hinge_r1,
									 cm_hinge_h - zpos + zpos2])
							rotate([0, 90, 0]) {
								cylinder(h = cm_hinge_w, r = cm_hinge_r1,
								        $fn = 30);
							}
						}
					}
					translate([i * camh_w / 2 -
					         (i == -1 ? cm_hinge_w : 0) +
					         i * 2 * tolerance - 0.1,
						     yneg - cm_hinge_off - cm_hinge_r1 - 0.22,
						     cm_h - 0.12])
					rotate([0, 90, 0]) {
						cylinder(h = cm_hinge_w + 0.2, r = cm_hinge_r2,
						        $fn = 20);
					}
				}
			}

			// handle
			translate([camh_w / 2 + 2 * tolerance - cm_h_w, yneg -
			         cm_h_l + cm_h_r, cm_h_h - cm_h_r])
			rotate([0, 90, 0])
			linear_extrude(height = cm_h_w) {
				difference() {
					minkowski() {
						square([cm_h_h - 2 * cm_h_r, cm_h_l]);
						circle(r = cm_h_r, $fn = 20);
					}
					translate([0, -cm_h_r + cm_h_th]) {
						square([cm_h_h - 2 * cm_h_r, cm_h_l - cm_h_th]);
					}
					assign(r2_off = 0.325)
					for(i = [-1 : 2 : 1]) {
						translate([(i == -1 ? (cm_h_h - cm_h_r) : 0) -
						         cm_h_r / 2 + i * r2_off, -cm_h_r +
						         cm_h_l / 2 + cm_h_r2]) {
							circle(r = cm_h_r2, $fn = 20);
						}
					}
				}
			}
		}
		translate([-cm_w / 2 + cm_th, yneg + cm_th, cm_th]) {
			cube([cm_w - 2 * cm_th, cm_l - 2 * cm_th,
			    cm_h - cm_th + 0.1]);
		}
		child();
	}
}

/**
 * Camera holder
 *
 * This part attaches the camera mount to the body
 *
 * @id plsq-camera-holder
 * @name PLSQ Camera Holder
 * @category Printed
 */
module camera_holder() {
	assign(negy = -1.855)
	translate([0, negy, camh_h2 / 2]) {
		difference() {
			union() {
				cube([camh_w, camh_l, camh_h2], center = true);
				// Hinges
				translate([-0.309 * camh_w,
					     -camh_l / 2 - camh_hinge2_r2 - camh_hinge2_off,
				        -camh_h2 / 2]) {
					hinge(camh_hinge2_off, camh_hinge2_w,
					     camh_hinge2_r1, camh_hinge2_r2, camh_hinge2_r3);
				}
				translate([camh_w / 2, camh_l / 2 + camh_hinge1_r2 +
				         camh_hinge1_off, -camh_h2 / 2])
				rotate([0, 0, 180]) {
					hinge(camh_hinge1_off, camh_hinge1_w,
					     camh_hinge1_r1, camh_hinge1_r2, camh_hinge1_r3);
				}
				translate([-camh_w / 2 + camh_hinge1_w, camh_l / 2 +
				         camh_hinge1_r2 + camh_hinge1_off, -camh_h2 / 2])
				rotate([0, 0, 180]) {
					hinge(camh_hinge1_off, camh_hinge1_w,
					     camh_hinge1_r1, camh_hinge1_r2, camh_hinge1_r3);
				}
			}
			translate([-camh_w / 2, camh_l / 2 - camh_pad2, 0]) {
				// h2
				translate([0, 0, camh_h2 / 2 - (camh_h2 - camh_h1)]) {
					cube([camh_w + 0.1, camh_pad2 + 0.1, camh_h2 - camh_h1]);
				}
				// canopy cutout
				translate([0, -camh_can_sec_l, -camh_h2 / 2 +
				         camh_can_sec_h]) {
					cube([camh_w + 0.1, camh_can_sec_l, camh_h2 -
					    camh_can_sec_h]);
				}
				// I never get tired of trigonometry :-)
				assign(c = camh_tap_sec_l / cos(camh_tap_angle))
				assign(o1 = sin(camh_tap_angle) * camh_tap_sec_l)
				translate([0, -camh_can_sec_l - camh_pad1 - camh_camh_sec_l,
				         -camh_h2 / 2]) {
					// chassis cutout
					cube([camh_w + 0.1, camh_camh_sec_l, camh_camh_sec_h]);
					// tapered edges
					rotate([0, 0, 180 + camh_tap_angle]) {
						cube([o1, c, camh_h2 + 0.2]);
					}
					translate([camh_w, 0, 0])
					rotate([0, 0, -90 - camh_tap_angle]) {
						cube([c, o1, camh_h2 + 0.2]);
					}
				}
			}
		}
	}
}

/**
 * Curved hinge for the camera holder
 *
 * @param float hinge_off Offset
 * @param float hinge_w The width of the hinge
 * @param float hinge_r1 First radius (curve)
 * @param float hinge_r2 Second radius (hinge)
 * @param float hinge_r3 Third radius (hole)
 */
module hinge(hinge_off, hinge_w, hinge_r1, hinge_r2, hinge_r3) {
	difference() {
		union() {
			cube([hinge_w, hinge_r2 + hinge_off,
			    2 * hinge_r2 + hinge_r1]);
			rotate([0, 90, 0])
			translate([-hinge_r2, 0, 0]) {
				cylinder(h = hinge_w, r = hinge_r2, $fn = 30);
			}
		}
		rotate([0, 90, 0]) {
			scale([1, (hinge_r1 + hinge_off / 2) / hinge_r1, 1])
			translate([-2 * hinge_r2 - hinge_r1, 0, 0]) {
				cylinder(h = hinge_w + 0.1, r = hinge_r1, $fn = 30);
			}
			translate([-hinge_r2, 0.15, 0]) {
				cylinder(h = hinge_w + 0.1, r = hinge_r3, $fn = 20);
			}
		}
	}
}
