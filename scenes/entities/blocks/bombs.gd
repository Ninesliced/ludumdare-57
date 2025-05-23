extends Node2D
class_name Bombs

const BOMB_RADUIS = 3

@export var break_bedrock: bool = false;
var collected : bool = false
@onready var sprite: AnimatedSprite2D = %Sprite2D


func _on_area_2d_body_entered(body:Node2D) -> void:
	if !is_instance_of(body, Player):
		return
	if collected:
		return
	collected = true
	var globalMap: TileMapLayer = get_tree().get_first_node_in_group("globalTileMap")
	if(!globalMap):
		return
	sprite.hide()
	var int_position = Vector2i(sprite.global_position)/16
	var cells = []
	for dx in range(-BOMB_RADUIS, BOMB_RADUIS):
		for dy in range(-BOMB_RADUIS, BOMB_RADUIS):
			if dx*dx +dy*dy <= BOMB_RADUIS*BOMB_RADUIS:
				var mapcell = globalMap.get_cell_tile_data(int_position+Vector2i(dx, dy))
				if !mapcell:
					continue
				var is_bedrock = mapcell.get_collision_polygons_count(1) == 1
				if !break_bedrock && is_bedrock:
					continue
				cells.append(int_position+Vector2i(dx, dy))
	globalMap.set_cells_terrain_connect(cells, 0,-1)
				# globalMap.set_cell(int_position+Vector2i(dx, dy), -1)
	$OneShotParticle.play()
	queue_free()
