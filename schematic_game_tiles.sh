#!/bin/bash

# This file converts the game tiles obj file to a schematic file, and places it in the schematics plugin folder

desiredwidth=768
desiredscale=0.499481025231916836

cd ../ObjToSchematic

importpath=$(readlink -f ../tiles_obj_merged/game_tiles.obj)
exportpath=$(readlink -f ../boston-loader-server/plugins/BostonLoader/schematics/game_tiles.schematic)

npm run headless --importpath="${importpath}" --exportpath="${exportpath}" --desiredwidth=$desiredwidth --desiredscale=$desiredscale