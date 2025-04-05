extends Node2D
class_name Bombs

const BOMB_RADUIS = 3

var collected : bool = false
@onready var sprite: AnimatedSprite2D = %Sprite2D

func _on_area_2d_body_entered(body:Node2D) -> void:
	if collected:
		return
	collected = true
	var globalMap: TileMapLayer = get_tree().get_first_node_in_group("globalTileMap")
	if(!globalMap):
		return
	sprite.hide()
	print(sprite.global_position)
	var int_position = Vector2i(sprite.global_position)/16
	for dx in range(-BOMB_RADUIS, BOMB_RADUIS):
		for dy in range(-BOMB_RADUIS, BOMB_RADUIS):
			if dx*dx +dy*dy <= BOMB_RADUIS*BOMB_RADUIS:
				# globalMap.set_cells_terrain_connect([int_position+Vector2i(dx, dy)], -1, -1)
				globalMap.set_cell(int_position+Vector2i(dx, dy), -1)
				print(globalMap)
								
	print("explode")
	queue_free()
