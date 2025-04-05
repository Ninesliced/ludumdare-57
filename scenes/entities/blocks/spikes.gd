extends Node2D
class_name Spikes

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
	var globalPlayer: Player = get_tree().get_first_node_in_group("player")
	if(!globalPlayer):
		return
	sprite.hide()
	globalPlayer.remove_live()
	print("pik")
	queue_free()
