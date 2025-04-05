extends Node2D

var MAP_SIZE_X = 20;
var MAP_SIZE_Y = 12;
const NB_MINERAL = 5
var current_depth = 0;

const proba_ore = {
	"Diams": {
		"proba": 0.1,
		"tile_y": 0
	},
	"Ameth": {
		"proba": 0.1,
		"tile_y": 1
	},
	"Ameth2": {
		"proba": 0.1,
		"tile_y": 1
	},
	"Ameth3": {
		"proba": 0.1,
		"tile_y": 1
	},
	"Ameth4": {
		"proba": 0.1,
		"tile_y": 1
	}
}

func get_random_ore():
	var random_val = randf()
	var total_proba = 0.0
	for proba_key in proba_ore.keys():
		var proba_val = proba_ore[proba_key]
		total_proba += proba_val["proba"]
		if total_proba > random_val:
			return proba_val
	return null

var layers = ["LayerA.tscn"]
var rng = RandomNumberGenerator.new();

func load_new_layer():
	var layerA_ressources = load("res://scenes/map/layer/"+layers.pick_random())
	var layerA: Node2D = layerA_ressources.instantiate()
	var oresMap: TileMapLayer = layerA.get_node("Ores")
	var mapMap: TileMapLayer = layerA.get_node("Map")
	for pixelx in range(MAP_SIZE_X):
		for pixely in range(MAP_SIZE_Y):
			var mapcell = mapMap.get_cell_tile_data(Vector2i(pixelx, pixely))
			if(is_instance_of(mapcell, TileData)):
				var random = get_random_ore()
				if(random != null):
					print(random.tile_y)
					oresMap.set_cell(Vector2i(pixelx, pixely), 2, Vector2(random.tile_y, 4))
	
	layerA.position.y = current_depth*16
	current_depth += MAP_SIZE_Y
	add_child(layerA)
	
func _ready():
	load_new_layer()
	print(current_depth)
	
