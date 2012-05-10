include <plsq.scad>
include <legs.scad>
include <body.scad>
include <canopy.scad>
include <arm.scad>
include <motor_mount.scad>
include <camera.scad>

rotate([0, 0, -100]) {
	translate([0, 0, l_cam_h]) {
		rotate([0, 180, -90]) {
			legs(camera = true, rafts = false);
		}
		body(rafts = false);
		translate([-6, 0, -4])
		rotate([0, 0, -90]) {
			canopy(receiver = true);
		}
	
		assign(diag = ch_45_diag - ch_45_l / 2)
		assign(vert = a_short_r - a_tall_th)
		for(i = [45 : 90 : 360 - 45]) {
			rotate([90, 0, i]) {
				translate([0, vert, diag])
				rotate([0, 0, -135]) {
					arm(raft = false);
				}
				rotate([-90, -2, 0])
				translate([diag + a_tall_h + a_short_h - a_slot_upper_h +
				         mm_arm_half1 - 2.5, a_tall_r - 0.25, 
				         a_short_r - a_tall_r - a_tall_th]) {
					motor_mount(raft = false);
				}
			}
		}
	}
	
	translate([75, 0, 20])
	rotate([0, 0, -90]) {
		translate([0, -30.5, 38.5]) {
			camera_holder();
		}
		gopro_camera_mount();
	}
}
