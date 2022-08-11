#!/bin/bash

# this file will loop through all tiles folders zip the .skp file, if it exists

cd ../tiles

for filename in ./*/; do
    [ -e "$filename" ] || continue
    [[ "$filename" == *"_"* ]] || continue
    id=${filename:2:-1}

    echo "===CONVERTING $id"
    cd $id
    file=$(find -name *.skp)
    if [[ ! -z "$file" ]]; 
    then
        echo "FOUND $file"
        zip $id.zip $file
        rm $file
    fi
    cd ..
done