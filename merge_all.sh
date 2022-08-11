#!/bin/bash

# this file will loop through all tiles in tiles and merge buildings together, resulting in tiles_obj, using the "merge_obj.py" python script
# example id: H_4

# obtain PATH_TO_BLENDER variable
source .env

cd ..

mkdir -p tiles_obj_merged

cd tiles

for filename in ./*/; do
    [ -e "$filename" ] || continue
    id=${filename:2:-1}
    path="../tiles_obj_merged/BOS_${id}_20210806.obj"
    result=$(readlink -e $path)
    if [ "$result" != "" ]; then
        echo "$id exists."
        continue
    fi
    [[ "$filename" == *"_"* ]] || continue

    echo "===CONVERTING $id"
    DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../convert/merge_obj.py $id
    sleep 0.1
done