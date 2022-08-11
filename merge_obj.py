import sys
import bpy
import os

def import_obj(file_loc):    
    bpy.ops.import_scene.obj(filepath=file_loc)
    
    if "Active Camera" in bpy.data.objects:
        bpy.ops.object.select_all(action='DESELECT')
        bpy.data.objects["Active Camera"].select = True
        bpy.ops.object.delete() 

def pre_simplify_scene():
    bpy.ops.object.select_all(action='DESELECT')
    bpy.data.objects["Camera"].select = True
    bpy.data.objects["Cube"].select = True
    bpy.data.objects["Lamp"].select = True
    bpy.ops.object.delete() 
    
def simplify_scene():
    # simplify the mesh; merge all objects
    bpy.ops.object.select_all(action='SELECT')
    selected = False
    for obj in bpy.context.scene.objects:
        if "Terrain" in obj.name:
            bpy.data.objects[obj.name].select = False
            print("Deselected the terrain object")
        else:
            bpy.context.scene.objects.active = bpy.data.objects[obj.name]
            selected = True
    if selected:
        bpy.ops.object.join()
    

def export_obj(file_loc, name):
    blend_file_path = bpy.data.filepath
    directory = os.path.dirname(blend_file_path)
    target_file = os.path.join(directory, file_loc)
    
    print("OBJ FILES ARE: " + str(len(bpy.data.objects)))
    for obj in bpy.data.objects:
        print(obj.name)

    bpy.ops.export_scene.obj(filepath=target_file)
    
    # fix mtl file
    lines = []
    new_lines = []
    with open("../tiles_obj_merged/" + name + ".mtl") as file:
        lines = file.readlines()
                
        size = len(lines)
        last_newmtl = None
        for i in range(size):
            line = lines[i].strip()
            if last_newmtl is not None:
                split = last_newmtl.split(" ")[1].split("_")
                new_lines.append("map_Kd ./BOS_" + split[1] + "_" + split[2] + "_Groundplan_2011.png\n")
                last_newmtl = None
            
            if not line.startswith("map_Kd"):
                new_lines.append(lines[i])
                if line.startswith("newmtl ") and line.endswith("jpg"):
                    last_newmtl = line
    with open("../tiles_obj_merged/" + name + ".mtl", "w") as file:
        file.write("".join(new_lines))

if __name__ == "__main__":
    name = sys.argv[-1]
    
    name = "BOS_" + name + "_20210806"
    
    pre_simplify_scene()    
    import_obj("../tiles_obj/" + name + ".obj")
    simplify_scene()
    export_obj("../tiles_obj_merged/" + name + ".obj", name)