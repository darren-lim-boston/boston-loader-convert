#!/bin/bash

# this file will loop through all merged tiles in tiles_obj_merged and extract only the terrain, resulting in tiles_terrain, using the "extract_terrain.py" python script

# obtain PATH_TO_BLENDER variable
source .env

cd ..

mkdir -p tiles_terrain

cd tiles_obj_merged

declare -a arr=("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P")

for letter in "${arr[@]}"; do
    if [[ "$letter" == *"," ]]; then
        letter=${letter:0:-1}
    fi
    
    path="../tiles_terrain/terrain_only_${letter}.obj"
    result=$(readlink -e $path)
    if [ "$result" != "" ]; then
        echo "$letter exists, skipping."
        continue
    fi

    echo "===CREATING TERRAIN FOR LETTER $letter"
    DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../convert/extract_terrain.py $letter
    sleep 0.1
done