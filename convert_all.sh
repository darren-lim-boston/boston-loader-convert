#!/bin/bash

# this file will loop through all tiles and convert them to a obj file, using the "convert.py" python script
# example id: H_4

# obtain PATH_TO_BLENDER variable
source .env

if [ "${PATH_TO_BLENDER}" == "" ]; then
    echo "You must configure the PATH_TO_BLENDER in .env correctly before continuing."
    exit
fi

cd ../tiles

for filename in ./*/; do
    [ -e "$filename" ] || continue
    [[ "$filename" == *"_"* ]] || continue
    id=${filename:2:-1}

    echo "===CONVERTING $id"
    cd $id
    DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../../convert/convert.py $id
    cd ..
    sleep 0.2
done