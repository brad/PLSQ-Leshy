/**
 * PLSQ Leshy
 *
 * @id plsq-leshy
 * @root
 * @name PLSQ Leshy
 * @using 1 glue
 * @using 4 plsq-arm
 * @using 4 plsq-motor-mount
 * @using 1 plsq-camera-holder
 * @using 1 plsq-camera-mount
 * @using 1 plsq-canopy
 * @using 1 plsq-body
 * @using 1 plsq-legs
 */

/********************
 * Global variables *
 *******************/
debug = true;
th = 0.3;
// Amount of space to leave between press-fit parts
tolerance = 0.25;

/**************************************
 * Arm measurements, prefixed with a_ *
 *************************************/
a_raft_r = 30.6;
a_overlap = 20;
a_short_h = 4;
a_short_r = 12.6;
a_tall_h = 140;
a_tall_r = 8.75;
a_tall_th = 2;
a_slot_w = 5.5;
a_slot_lower_h = 25.48;
a_slot_upper_h = 22;
a_coupler_h = 30;

/*******************************************
 * Chassis measurements, prefixed with ch_ *
 *******************************************/
ch_full_l = 90;
ch_45_l = 2 * a_short_r + 3.0843;
ch_short_l = ch_full_l - 2 * cos(45) * ch_45_l;
ch_90_th = 7.05;
ch_45_th = 6.51;
ch_45_diag = (ch_full_l / 2) / cos(45);
ch_full_h = 4.05;
ch_cutout_w = 3;
ch_cutout_th = 0.75;
ch_cutout_front_th = 1.1;
ch_cutout_back_th = 0.75;
ch_cutout_ratio = 0.14;

/***************************************
 * Body measurements, prefixed with b_ *
 **************************************/
b_h = 2 * a_short_r - (a_short_r - a_tall_r) - ch_full_h;
b_beam_h = 3.6;
b_beam_w = 2 * a_tall_r - 2 * a_tall_th;
b_beam_trim = 0.78;
b_arm_r = a_tall_r - a_tall_th - tolerance;
b_arm_th = 2.9;
b_beam_cyl_h = 3;
b_beam_cyl_r = 3.01;
b_beam_cyl_th = 1.5;
b_beam_cyl_place = 0.6815 * (ch_45_diag - ch_45_l / 2 - b_beam_w);

/*****************************************
 * Canopy measurements, prefixed with c_ *
 ****************************************/
c_45_l = 2 * a_short_r + 2;
// Lengths of sides of different cross-sections
c_bottom_l = ch_full_l + 8.5;
c_middle_l = 0.9877 * c_bottom_l;
c_top_l = 0.5707 * c_bottom_l;
// Heights of different sections
c_bottom_h = 2 * a_tall_r + 14.1;
c_top_h = 0.519 * c_bottom_h;
// Thickness of the canopy walls
c_th = 2;
// Window dimensions
c_window_w = 2 * (a_tall_r + 0.45);
c_window_h = b_h + 5.63;
// Width of the receiver bay
c_receiver_w = 12;
c_receiver_angle = 20;
c_text = "Leshy";

/**************************************
 * Leg measurements, prefixed with l_ *
 *************************************/
l_leg_l = 25;
l_leg_th = a_slot_w - 0.5;
l_cam_h = 70;
l_h = 50;
l_raft_r = 10;
l_strip_ratio = 0.5;
l_camera_strip_offset = 2.6;
l_camera_thin_th = 7.45;
l_camera_thick_th = 18.6;
l_camera_thick_ratio = 0.622;

/***********************************************
 * Motor mount measurements, prefixed with mm_ *
 ***********************************************/
mm_open_l = 32;
mm_open_pad1 = 2;
mm_open_pad2 = 3.4;
mm_arm_l = a_slot_upper_h - 1 + mm_open_l + mm_open_pad1 + mm_open_pad2;
mm_arm_half1 = 0.61 * mm_arm_l;
mm_raft_r = 10;
mm_arm_short_r = a_tall_r - a_tall_th - tolerance;
mm_arm_th = 3;
mm_arm_tall_th = 2.4;
mm_arm_tall_r = a_tall_r;
mm_arm_runner = a_slot_w - 2 * tolerance;
mm_cup_base_h = 5;
mm_cup_h1 = 15;
mm_cup_h2 = mm_cup_h1 + mm_cup_base_h + 3;
mm_cup_r1 = 18;
mm_cup_r2 = mm_cup_r1 - 2;
mm_cup_r3 = mm_cup_r2 + 2 * tolerance;
mm_cup_th = 1;
// cup depression
mm_cup_dep_r1 = 4.1;
mm_cup_dep_r2 = 4.53;
mm_cup_dep_h = 3;
mm_cup_hole_h1 = 2.2;
mm_cup_hole_h2 = 0.5;
mm_cup_hole_r1 = 3.1;
mm_cup_hole_r2 = 1.68;

/*************************************************
 * Camera holder measurements, prefixed with camh_ *
 ************************************************/
camh_h1 = 13;
camh_h2 = 14;
camh_w = ch_short_l - 2 * ch_cutout_ratio * ch_short_l -
      2 * ch_cutout_w - 0.15;
camh_th = 0.65;
camh_pad1 = 1.5;
camh_pad2 = 2;
// tapered section
camh_tap_sec_l = 0.26 * (ch_full_l / 2 - l_camera_thick_th -
                 ch_90_th);
camh_tap_angle = 32;
// chassis section
camh_camh_sec_l = ch_90_th + 2 * camh_th + 0.2;
camh_camh_sec_h = camh_h2 - 2.5;
// canopy section
camh_can_sec_l = 4;
camh_can_sec_h = 3;
// Hinges
camh_hinge1_r1 = 5;
camh_hinge1_r2 = 3.9;
camh_hinge1_r3 = 1.5;
camh_hinge1_w = 8.5;
camh_hinge1_off = 2;
camh_hinge2_r1 = 3;
camh_hinge2_r2 = 2.32;
camh_hinge2_r3 = 0.5;
camh_hinge2_w = 2.5;
camh_hinge2_off = 1.4;
camh_l = camh_tap_sec_l + camh_pad1 + camh_pad2 +
         camh_camh_sec_l + camh_can_sec_l;

/************************************************
 * Camera mount measurements, prefixed with cm_ *
 ***********************************************/
cm_w = 65;
cm_l = 35;
cm_h = 43.9;
cm_th = 2;
cm_hinge_off = 1.5;
cm_hinge_w = 11;
cm_hinge_h = 11;
cm_hinge_r1 = 3.475;
cm_hinge_r2 = 1.425;
cm_h_w = 9;
cm_h_h = 33;
cm_h_l = 14;
cm_h_r = 4.3;
cm_h_th = 1.5;
cm_h_r2 = 1;
