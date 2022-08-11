#!/bin/bash

# runs the obtain_game_tiles script

# obtain PATH_TO_BLENDER variable
source .env

cd ../tiles_obj_merged

DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../convert/obtain_game_tiles.py