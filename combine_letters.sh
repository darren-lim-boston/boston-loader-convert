#!/bin/bash

# this file will loop through all obj files in tiles_obj_merged and merge based on letter, using the "combine.py" python script

# obtain PATH_TO_BLENDER variable
source .env

cd ../tiles_obj_merged

declare -a arr=("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P")

for letter in "${arr[@]}"; do
    if [[ "$letter" == *"," ]]; then
        letter=${letter:0:-1}
    fi
    path="../tiles_obj_merged/combined_${letter}.obj"
    result=$(readlink -e $path)
    if [ "$result" != "" ]; then
        echo "$letter exists."
        continue
    fi

    echo "===MERGING $letter"
    DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../convert/combine.py $letter
    sleep 0.1
done