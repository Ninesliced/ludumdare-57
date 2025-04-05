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
	current_depth += MAP_SIZE_Y
	add_child(layerA)
	
func _ready():
	load_new_layer()
	print(current_depth)
	
