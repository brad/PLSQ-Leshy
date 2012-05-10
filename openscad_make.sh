#!/bin/bash

while read data; do
    echo $data > $1.scad 
done

openscad -m make -o $1 -d $1.deps $1.scad
