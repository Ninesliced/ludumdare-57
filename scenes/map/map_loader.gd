extends Node2D

var MAP_SIZE_X = 22;
var MAP_SIZE_Y = 12;
var current_depth = 0;

const proba_ore = {
	"Ruby": {
		"proba": 0.01,
		"tile_id": 1
	},
	"Emerald": {
		"proba": 0.02,
		"tile_id": 2
	},
	"Topaz": {
		"proba": 0.01,
		"tile_id": 3
	},
	"Diamond": {
		"proba": 0.005,
		"tile_id": 4
	},
	"Amethyst": {
		"proba": 0.002,
		"tile_id": 5
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



var top_layer_ressources = preload("res://scenes/map/layer/top_layer.tscn").instantiate()
var layerA_instance = preload("res://scenes/map/layer/LayerA.tscn").instantiate()
var layerB_instance = preload("res://scenes/map/layer/LayerB.tscn").instantiate()
var layerC_instance = preload("res://scenes/map/layer/LayerC.tscn").instantiate()

var layers_ressources = [layerA_instance,layerA_instance, layerA_instance, layerC_instance, layerC_instance, layerB_instance]
var rng = RandomNumberGenerator.new();

"""
func load_new_layer_old():
	if current_depth == 0:
		var layerA_ressources = load("res://scenes/map/layer/top_layer.tscn")
		var layerA: Node2D = layerA_ressources.instantiate()
		current_depth += MAP_SIZE_Y
		add_child(layerA)
		return
	var layerA_ressources = load("res://scenes/map/layer/"+layers.pick_random())
	var layerA: Node2D = layerA_ressources.instantiate()
	var oresMap: TileMapLayer = layerA.get_node("Ores")
	var mapMap: TileMapLayer = layerA.get_node("Map")
	for pixelx in range(-1, MAP_SIZE_X):
		for pixely in range(MAP_SIZE_Y):
			var mapcell = mapMap.get_cell_tile_data(Vector2i(pixelx, pixely))
			if(is_instance_of(mapcell, TileData)):
				var random = get_random_ore()
				if(random != null):
					oresMap.set_cell(Vector2i(pixelx, pixely) ,3 ,Vector2i(0,0), random.tile_id)#, Vector2(random.tile_y, 4))
	
	layerA.position.y = current_depth*16
	current_depth += MAP_SIZE_Y
	add_child(layerA)
"""

var Map: TileMapLayer;

func load_new_layer():
	var layerA
	if current_depth == 0:
		layerA = top_layer_ressources
	else:
		layerA = layers_ressources.pick_random()
	#var layerA: Node2D = layerA_ressources.instantiate()
	var oresMap: TileMapLayer = layerA.get_node("Ores")
	var mapMap: TileMapLayer = layerA.get_node("Map")
	var bgMap: TileMapLayer = layerA.get_node("Background")
	
	for pixelx in range(-1,MAP_SIZE_X):
		for pixely in range(MAP_SIZE_Y):
			var relative_coords = Vector2i(pixelx, pixely)
			var mapcell = mapMap.get_cell_tile_data(relative_coords)
			var atlas_coords = mapMap.get_cell_atlas_coords(relative_coords)
			var source_id = mapMap.get_cell_source_id(relative_coords)
			var alternative_tile = mapMap.get_cell_alternative_tile(relative_coords)
			if mapcell && is_instance_of(mapcell, TileData) && Map:
				var is_bedrock = mapcell.get_collision_polygons_count(1) == 1
				# Map.set_cells_terrain_connect([Vector2i(pixelx, pixely+current_depth)], 0, -1)
				if source_id == 2: # Si on est sur la map des blocks
					Map.set_cells_terrain_connect([Vector2i(pixelx, pixely+current_depth)], 0, 1 if is_bedrock else 0)
				else: # Nimporte quoi d'autre comme le bonhomme de neige
					Map.set_cell(Vector2i(pixelx, pixely+current_depth), source_id, atlas_coords, alternative_tile)
				var random = get_random_ore()
				# mapcell.get_collision_polygons_count(1) == 0 :: C'est un block placabke
				if(random != null) && current_depth != 0 && mapcell.get_collision_polygons_count(1) == 0:
					%Ores.set_cell(Vector2i(pixelx, pixely+current_depth) ,3 ,Vector2i(0,0), random.tile_id)#, Vector2(random.tile_y, 4))
			if bgMap && bgMap.get_cell_tile_data(relative_coords) && is_instance_of(bgMap.get_cell_tile_data(relative_coords), TileData):
				%Background.set_cell(Vector2i(pixelx, pixely+current_depth), bgMap.get_cell_source_id(relative_coords), bgMap.get_cell_atlas_coords(relative_coords), bgMap.get_cell_alternative_tile(relative_coords))
	# layerA.position.y = current_depth*16
	current_depth += MAP_SIZE_Y
	# add_child(layerA)


func _ready():
	Map = %GlobalTileMap;
	load_new_layer()
	
func _process(delta):
	var player: Player = get_tree().get_first_node_in_group("player")
	if(is_instance_of(player, Player)):
		var posy = player.position.y
		if posy > (current_depth-MAP_SIZE_Y)*16:
			load_new_layer()

func reset_map():
	%GlobalTileMap.clear()
	%Ores.clear()
	current_depth = 0
	print("TODO")
