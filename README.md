# What is this?

This folder contains the python files and Bash scripts necessary to convert files from .obj format to .schematic, so that 3D models can be converted into a format friendly with Minecraft. In this specific use case, we are converting the [TILES from the BPDA 3D data download](http://www.bostonplans.org/3d-data-maps/3d-smart-model/3d-data-download) website from sketchup format to obj format, combining them into simplified obj files, and creating schematic files from those combined files.

Note that although the scripts were created in order to simplify the tile creation, the time constraint over the summer made it more difficult to simplify the process to as much as possible. Therefore, running these scripts may take some patience, since it is definitely possible the scripts might need to be slightly tweaked to work correctly.

# Prerequisites

- A Linux machine should be running the scripts. I used a Ubuntu distribution for my tests, but any distro should work as long as the below is installed.

- Python 3 is installed, and Bash

- blender 2.79b WINDOWS version should be downloaded; for example, I placed mine at "/home/NAME/Documents/blender-2-78b-windows64/blender.exe"

    - We use the Windows version because the sketchup importer plugin below does not work with Linux. Possible work can be done to convert the plugin into a Linux-friendly format, then the scripts can be run without WINE.

- Should have downloaded the sketchup importer plugin (https://github.com/martijnberger/pyslapi) if you need to convert sketchup files into obj files

- Should have the WINE package installed to run blender windows

    - WINE is necessary to run Windows programs on a Linux machine

# How to run the scripts

Note that not all scripts will be needed to convert the models.

## Precautionary note:

- There is a good chance that if the models need to be updated, the files will be renamed as well. The scripts unfortunately depend on the names of the files being exactly as they are as of the time of download (which is Summer 2022), so if this changes, either the scripts will need to be revised or the filenames need to be changed to match the expected filenames. Namely, some files in particular that may change name that the scripts depend on:

    - BOS_A_9_20210806.skp (requires the number to be right)
    - BOS_A_9_Groundplan_2011.png (requires 2011 to be right)

## Guide:

Below, there are steps regarding the overall process needed to convert the BPDA's sketchup files into object files, and finally into schematic files that can be loaded into Minecraft using the boston-loader-plugins/boston-loader plugin. When needing to create new 3D models into Minecraft, run only the scripts necessary and adjust the scripts as necessary. **The below code snippets should be run in a terminal.**

NOTE: **YOU MUST specify the correct PATH_TO_BLENDER, which is the absolute path to the blender.exe file, in a file named .env in this folder. Otherwise, the code WILL NOT know where Blender is located!**. Make sure you load the .env file before running the below commands. One such way to do this before running the scripts below is to call:

    export PATH_TO_BLENDER="..."

Some examples of how to specify this variable is below:

    PATH_TO_BLENDER=**specify your whole path to the blender.exe file**

    for example: PATH_TO_BLENDER=/home/NAME/Documents/blender-2.79b-windows64/blender.exe

Before you begin: create a folder above this directory called **tiles**, and place sub-directories for each tile. Each sub-directory should include:

- the .sketchup file
- the Groundplan_2011.png file. You must convert each jpg file to png by any means. One easy way is to batch convert using the [mogrify](https://imagemagick.org/script/mogrify.php) command.

## Example files:

    tiles/
        A_9/
            A_9_20210806.skp
            BOS_A_9_Groundplan_2011.png
        ...

- put the skp file in there (ex: BOS_A_9_20210806.skp), and the BOS_A_9_Groundplan_2011.png file (must convert from jpg to png; ex: mogrify to batch convert)

## Steps:

0) Make sure you have the .env file configured correctly. See above for details!!! (the scripts will not work without this .env file)

1) Call convert_all.sh to convert all .skp to .obj files. the outputs will be placed in the tiles subfolders themselves, as .obj and .mtl files. ENSURE THAT the .mtl file has a map_Kd entry that resembles:

        map_Kd ./BOS_A_9_Groundplan_2011.png

- If this is not the case, then you may need to manually edit the .mtl files to have this, potentially replacing the old map_Kd entry. This will allow the terrain to retain its colored texture in the final version!

2) Call move_to_tiles_obj.sh to move tiles into a new tiles_obj folder. This script moves all relevant files to a new organized folder.

3) Call merge_all.sh to merge the buildings of each .obj file into one object, placing the merged files into tiles_obj_merged. This will simplify calculations in the future (optional, recommended).

- *OPTIONAL*: If you want to modify the resulting textures, modify the images in the tiles_obj_merged folder before continuing, so that terrain will render differently. FOR EXAMPLE:
    - The water is currently rendered incorrectly unless this is fixed in the images (they will render as white concrete in-game). To make water render correctly, run this command in the tiles_obj_merged folder using mogrify:
    
        - `mogrify -fill "#00286d" -opaque "#85bacc" *.png`

4) Call combine_letters.sh to merge the same letters together into one .obj file each, placing them into tiles_obj_merged once again as combined_X.obj and combined_X.mtl. This is done to try to reduce the "stitching" rounded error that will be described below in more detail.

- *Caution*: ensure at this stage that the *.mtl files in the combined_X.mtl are formatted correctly with the correct map_Kd as described above for each terrain tile. If this is not right, then the terrain will render without any color!

5) Run schematic_all.sh to create the Minecraft schematics! Before running, you can change the output folder in the script.

- *Optional*: You can modify the schematic_all.sh file to adjust the output folder or the output width of the tiles. Look at the `desiredwidth`, `desiredscale`, and `schematics_folder` variables and adjust accordingly. Note that if you adjust the `desiredwidth`, you MUST adjust the `desiredscale` as well proportionally (it scales linearly, so simply do the calculations to adjust accordingly). `desiredscale` can be optional if only `desiredwidth` is given.

6) Move the schematic files into the server (to the boston-loader-server/plugins/BostonLoader/schematics folder), run your server, and load the schematics using the BostonLoader plugin! (/boston build <name of schematic>). The schematic will be loaded relative to your current location if this is your first "build," or relative to your first location otherwise.

- ***Note***: The output combined object files will be placed as best as possible to the correct locations relative to each other, but because of rounding errors as each .obj is converted into .schematic, you may find that the resulting Minecraft output blocks have gaps between each built Combined column. You may need to adjust accordingly to fix these gaps if this is a problem, or fill in the gaps.

    - For future work, this gap can be reduced or removed completely if the tile files are fixed and re-tiled. Currently, the tiles are not completely encapsulated into the square dimensions given to it, since some buildings, if they overlap between multiple tiles, will only be built in one tile, thus extending past the tile's square boundaries and bleeding into another tile. One such solution may involve importing all the tiles into Blender, then creating a new tiling that does not allow the tiles to extend past their square boundaries.

    - Note that we split the conversion from .obj to .schematic into columns because it is too computationally intensive to combine more tiles together. HOWEVER, this may be a point of future work in order to remove this gap by figuring out a way to optimize ObjToSchematic (and possibly the boston-loader importing script as well) in order to get the entire City of Boston loaded in one go! This is harder but if done right, will definitely remove gaps.

7) Profit!

# Conversion statistics (benchmarks)

I used an 8-core desktop with 16GB RAM to run these test benchmarks. Your times may vary.

108 tiles total, set to render at 512x512 blocks each in Minecraft

.SKP -> .OBJ: each can take 1-2 minutes each

- overall, that's up to 3 hours to convert the .skp to .obj

16 columns of tiles, combined (one per letter)

- To convert all columns from .obj -> .schematic: takes around 3.5 hours

Change is possible, takes a long time

NOTE: the game_tiles are rendered at a higher resolution of 768x768. When rendering at 768x768, this seems to take exponentially longer to run, so only 9 tiles are rendered for the game. See `obtain_game_tiles.py` for which tiles are used for the game. Additionally, since not all tiles are explored in the games themselves, the tiles that are farther away from the player are rendered at a reduced quality, which allows the game to run faster. See the tiles ABOVE `simplify_scene()`, which are rendered at a lower quality.

# OLD debug commands (ignore, optional)

### Base command to convert sketchup files into obj files:

        DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P convert.py

### corrected command to be used in a script for automation (from the point of the subfolder, ex H_4):

        DISPLAY=:0.0 wine $PATH_TO_BLENDER -b -P ../../convert/convert.py BOS_H_4_20210806

### how to convert jpg to png (make sure you modify mtl file correctly)

        mogrify -format png BOS_H_4_Groundplan_2011.jpg

### Modify mtl file: add

        map_Kd ./BOS_H_4_Groundplan_2011.png

        # underneath the jpg definition