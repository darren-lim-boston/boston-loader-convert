#!/bin/bash

# This file will create a schematic for all letters. The desired width is defined below:

desiredwidth=512
desiredscale=0.33595717108796885

# desiredwidth=768
# desiredscale=0.499481025231916836

schematics_folder="schematics_output"

# Below is the code.

cd ..

mkdir -p $schematics_folder

cd ObjToSchematic

npm run build

declare -a arr=("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P")

for letter in "${arr[@]}"; do
    if [[ "$letter" == *"," ]]; then
        letter=${letter:0:-1}
    fi
    
    path="../$schematics_folder/combined_${letter}_${desiredwidth}.schematic"
    result=$(readlink -e $path)
    if [ "$result" != "" ]; then
        echo "$letter exists, skipping."
        continue
    fi

    importpath=$(readlink -f ../tiles_obj_merged/combined_${letter}.obj)
    exportpath=$(readlink -f ../$schematics_folder/combined_${letter}_${desiredwidth}.schematic)

    echo "===CREATING SCHEMATIC WIDTH $desiredwidth LETTER $letter"
    npm run headless --importpath="${importpath}" --exportpath="${exportpath}" --desiredwidth=$desiredwidth --desiredscale=$desiredscale
    sleep 0.1
done