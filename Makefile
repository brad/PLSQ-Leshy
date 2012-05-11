TARGETS=arm.stl arm_no_raft.stl arm_split.stl arm_split_no_raft.stl \
	arm_split_with_coupler.stl arm_split_with_coupler_no_raft.stl \
	body.stl body_no_rafts.stl camera_holder.stl canopy.stl \
	canopy_upside_down.stl canopy_upside_down_no_name.stl \
	canopy_with_receiver.stl canopy_with_receiver_no_name.stl \
	gopro_camera_mount.stl legs.stl legs_no_rafts.stl legs_camera.stl \
	legs_camera_no_rafts.stl motor_mount.stl motor_mount_no_raft.stl preview.stl

all: ${TARGETS}

arm.stl:
	echo 'include <arm.scad> arm();' | ./openscad_make.sh $@

arm_no_raft.stl:
	echo 'include <arm.scad> arm(raft = false);' | ./openscad_make.sh $@

arm_split.stl:
	echo 'include <arm.scad> split_arm();' | ./openscad_make.sh $@

arm_split_no_raft.stl:
	echo 'include <arm.scad> split_arm(raft = false);' | ./openscad_make.sh $@

arm_split_with_coupler.stl:
	echo 'include <arm.scad> split_arm(coupler = true);' | ./openscad_make.sh $@

arm_split_with_coupler_no_raft.stl:
	echo 'include <arm.scad> split_arm(raft = false, coupler = true);' | \
		./openscad_make.sh $@

body.stl:
	echo 'include <body.scad> body();' | ./openscad_make.sh $@

body_no_rafts.stl:
	echo 'include <body.scad> body(rafts = false);' | ./openscad_make.sh $@

camera_holder.stl:
	echo 'include <camera.scad> camera_holder();' | ./openscad_make.sh $@

canopy.stl:
	echo 'include <canopy.scad> canopy();' | ./openscad_make.sh $@

canopy_upside_down.stl:
	echo 'include <canopy.scad> canopy(upside_down = true);' | ./openscad_make.sh $@

canopy_upside_down_no_name.stl:
	echo 'include <canopy.scad> canopy(upside_down = true, text = false);' | \
		./openscad_make.sh $@

canopy_with_receiver.stl:
	echo 'include <canopy.scad> canopy(receiver = true);' | ./openscad_make.sh $@

canopy_with_receiver_no_name.stl:
	echo 'include <canopy.scad> canopy(receiver = true, text = false);' | \
		./openscad_make.sh $@

gopro_camera_mount.stl:
	echo 'include <camera.scad> gopro_camera_mount();' | ./openscad_make.sh $@

legs.stl:
	echo 'include <legs.scad> legs();' | ./openscad_make.sh $@

legs_no_rafts.stl:
	echo 'include <legs.scad> legs(rafts = false);' | ./openscad_make.sh $@

legs_camera.stl:
	echo 'include <legs.scad> legs(camera = true);' | ./openscad_make.sh $@

legs_camera_no_rafts.stl:
	echo 'include <legs.scad> legs(camera = true, rafts = false);' | \
		./openscad_make.sh $@

motor_mount.stl:
	echo 'include <motor_mount.scad> motor_mount();' | ./openscad_make.sh $@

motor_mount_no_raft.stl:
	echo 'include <motor_mount.scad> motor_mount(raft = false);' | \
		./openscad_make.sh $@

preview.stl:
	openscad -m make -o preview.stl -d preview.stl.deps preview.scad

documentation:
	rm -rf *.stl.scad && thingdoc && cd docs && pdflatex documentation.tex && cd ..
	thingdoc -g > docs/documentation.dot
	sed -i '/^.*\.tdoc/d' docs/documentation.dot
	sed -i '/^.*\.scad/d' docs/documentation.dot
	dot docs/documentation.dot -Tpng > docs/graph.png

release: ${TARGETS} documentation
	rm docs/*.aux docs/*.log docs/*.out docs/*.tex docs/*.toc docs/*.dot
	tar cz docs *.stl > plsq-leshy-compiled-`date +'%Y.%m.%d'`.tar.gz
	zip -r plsq-leshy-compiled-`date +'%Y.%m.%d'`.zip docs *.stl

clean_intermediates:
	rm -rf *.deps *.stl.scad docs

clean:
	rm -rf *.deps *.stl.scad docs *.stl
