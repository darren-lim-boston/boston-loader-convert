#!/bin/bash

# this file moves all tiles objects to the tiles_obj folder, along with its mtl and png

cd ..

mkdir -p tiles_obj

cd convert

echo "copying obj files over..."
find ../tiles/* -type f -name "*.obj" -exec cp {} ../tiles_obj \;
echo "copying mtl files over..."
find ../tiles/* -type f -name "*.mtl" -exec cp {} ../tiles_obj \;
echo "copying png files over..."
find ../tiles/* -type f -name "*.png" -exec cp {} ../tiles_obj \;
echo "done!"