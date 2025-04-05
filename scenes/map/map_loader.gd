extends Node2D

var MAP_SIZE_X = 20;
var MAP_SIZE_Y = 12;

var current_depth = 0;

var layers = ["LayerA.tscn"]

func load_new_layer():
	var layerA_ressources = load("res://scenes/map/layer/"+layers.pick_random())
	var layerA: Node2D = layerA_ressources.instantiate()
	var tileMapLayer: TileMapLayer = layerA.get_node("Ores")
	layerA.position.y = current_depth*16
	for pixelx in range(0, MAP_SIZE_X):
		for pixely in range(0, MAP_SIZE_Y):
			var current_pixel = tileMapLayer.get_cell_source_id(Vector2i(pixelx, pixely))
			var current_pixel2 = tileMapLayer.get_cell_tile_data(Vector2i(pixelx, pixely))
			print(current_pixel2)
			if(is_instance_of(current_pixel2, TileData)):
				print("\t", str(current_pixel2.get_property_list()))
		print("")
	current_depth += MAP_SIZE_Y
	add_child(layerA)
	
func _ready():
	load_new_layer()
	print(current_depth)
	
