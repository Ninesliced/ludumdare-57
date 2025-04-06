extends Node2D

var MAP_SIZE_X = 22;
var MAP_SIZE_Y = 12;
var current_depth = 0;

@export var proba_ruby: Curve
@export var proba_emerald: Curve
@export var proba_topaz: Curve
@export var proba_diamond: Curve
@export var proba_amethyst: Curve

@onready
var proba_ore = {
	"Ruby": {
		"curve": proba_ruby,
		"proba": 0.01,
		"tile_id": 1
	},
	"Emerald": {
		"curve": proba_emerald,
		"proba": 0.02,
		"tile_id": 2
	},
	"Topaz": {
		"curve": proba_topaz,
		"proba": 0.01,
		"tile_id": 3
	},
	"Diamond": {
		"curve": proba_diamond,
		"proba": 0.005,
		"tile_id": 4
	},
	"Amethyst": {
		"curve": proba_amethyst,
		"proba": 0.002,
		"tile_id": 5
	}
}


"""
Exemples, binomial:
|	<modulo>      <w>
|  xx      xx      x...  <-- Proba
| x  x    x  x    x ...
|x    xxxx    xxxx  ...
|---------------------------- w: width
{
	"methode_generation": "binomial",
	"width": 10 // en pixel (l'epaisseur de la binomiale)
	"proba": 0.01,
	"modulo": 10 // en pixel
	"tile_id": 3
}
Exemples, uniform:
|xxxxxxxxxxxxxxxxxxx...  <-- Proba
|                   ...
|                   ...
|----------------------------
{
	"methode_generation": "uniform",
	"proba": 0.01,
	"tile_id": 3
},
"""

func get_random_ore(depth_block: int):
	var depth_layer: float = float(depth_block)/float(MAP_SIZE_Y)
	var random_val = randf()
	var total_proba = 0.0
	for proba_key in proba_ore.keys():
		var proba_val = proba_ore[proba_key]
		
		if is_instance_of(proba_val.curve, Curve):
			var curve: Curve = proba_val.curve
			# var max_domain = curve.max_domain
			# curve.sample_baked(depth_layer)*proba_val.proba
			total_proba += curve.sample_baked(depth_layer)*proba_val.proba
		else:
			total_proba += proba_val.proba
		if total_proba > random_val:
			return proba_val
	return null



var top_layer_ressources = preload("res://scenes/map/layer/top_layer.tscn").instantiate()
var layerA_instance = preload("res://scenes/map/layer/LayerA.tscn").instantiate()
var layerB_instance = preload("res://scenes/map/layer/LayerB.tscn").instantiate()
var layerC_instance = preload("res://scenes/map/layer/LayerC.tscn").instantiate()
var layerD_instance = preload("res://scenes/map/layer/LayerD.tscn").instantiate()
var layerE_instance = preload("res://scenes/map/layer/LayerE.tscn").instantiate()
var layerF_instance = preload("res://scenes/map/layer/LayerF.tscn").instantiate()

var layers_ressources2 = [layerE_instance] 

var layers_ressources = [
						layerA_instance,layerA_instance, layerA_instance, 
						layerC_instance, layerC_instance, 
						layerD_instance,
						layerB_instance,
						layerE_instance,
						layerF_instance,]
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
	var bgDecMap: TileMapLayer = layerA.get_node("BackgroundDecoration")
	var itemMap: TileMapLayer = layerA.get_node("Items")

	var mapMapSizeY = mapMap.get_used_rect().size.y
	
	var bedrock_cell = []
	var normal_cell = []
	for pixelx in range(-1,MAP_SIZE_X):
		for pixely in range(0, mapMapSizeY - 1):
			var relative_coords = Vector2i(pixelx, pixely)
			var mapcell = mapMap.get_cell_tile_data(relative_coords)
			var atlas_coords = mapMap.get_cell_atlas_coords(relative_coords)
			var source_id = mapMap.get_cell_source_id(relative_coords)
			var alternative_tile = mapMap.get_cell_alternative_tile(relative_coords)
			if mapcell && is_instance_of(mapcell, TileData) && Map:
				var is_bedrock = mapcell.get_collision_polygons_count(1) == 1
				# Map.set_cells_terrain_connect([Vector2i(pixelx, pixely+current_depth)], 0, -1)
				if source_id == 2: # Si on est sur la map des blocks
					if is_bedrock:
						bedrock_cell.append(Vector2i(pixelx, pixely+current_depth))
					else:
						normal_cell.append(Vector2i(pixelx, pixely+current_depth))
				else: # Nimporte quoi d'autre comme le bonhomme de neige
					Map.set_cell(Vector2i(pixelx, pixely+current_depth), source_id, atlas_coords, alternative_tile)
				var random = get_random_ore(pixely+current_depth)
				# mapcell.get_collision_polygons_count(1) == 0 :: C'est un block placabke
				if(random != null) && current_depth != 0 && mapcell.get_collision_polygons_count(1) == 0:
					%Ores.set_cell(Vector2i(pixelx, pixely+current_depth) ,3 ,Vector2i(0,0), random.tile_id)#, Vector2(random.tile_y, 4))
			if bgMap && bgMap.get_cell_tile_data(relative_coords) && is_instance_of(bgMap.get_cell_tile_data(relative_coords), TileData):
				%Background.set_cell(Vector2i(pixelx, pixely+current_depth), bgMap.get_cell_source_id(relative_coords), bgMap.get_cell_atlas_coords(relative_coords), bgMap.get_cell_alternative_tile(relative_coords))
			if bgDecMap && bgDecMap.get_cell_tile_data(relative_coords) && is_instance_of(bgDecMap.get_cell_tile_data(relative_coords), TileData):
				%BackgroundDecoration.set_cell(Vector2i(pixelx, pixely+current_depth), bgDecMap.get_cell_source_id(relative_coords), bgDecMap.get_cell_atlas_coords(relative_coords), bgDecMap.get_cell_alternative_tile(relative_coords))
			if itemMap && itemMap.get_cell_alternative_tile(relative_coords) != -1:# && is_instance_of(itemMap.get_cell_tile_data(relative_coords), TileData):
				%Items.set_cell(Vector2i(pixelx, pixely+current_depth), 4, Vector2i(0,0), itemMap.get_cell_alternative_tile(relative_coords))
	# layerA.position.y = current_depth*16
	Map.set_cells_terrain_connect(bedrock_cell, 0, 1)
	Map.set_cells_terrain_connect(normal_cell, 0, 0)

	current_depth += mapMapSizeY - 1
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
	%Background.clear()
	%BackgroundDecoration.clear()
	%Items.clear()

	current_depth = 0
	print("TODO")
	
func spawn_bomb(_position):
	var bomb = preload("res://scenes/entities/blocks/bombs.tscn").instantiate()
	bomb.position = _position
	add_child(bomb)
	
func spawn_spikes(_position):
	var spikes = preload("res://scenes/entities/blocks/spikes.tscn").instantiate()
	spikes.position = _position
	add_child(spikes)
	
