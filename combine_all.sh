#!/bin/bash

# this file will loop through all obj files in tiles_obj_merged and merge based on letter, using the "combine.py" python script

# obtain PATH_TO_BLENDER variable
source .env

cd ../tiles_obj_merged

DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../convert/combine_all.py $letter