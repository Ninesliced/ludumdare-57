extends Node2D

class_name Ore

var collected : bool = false
@export var mineral: Inventory.Minerals = Inventory.Minerals.RUBY
@onready var destroyParticle : CPUParticles2D = %DestroyParticle
@onready var sprite: AnimatedSprite2D = %Sprite2D

func _on_area_2d_body_entered(body:Node2D) -> void:
	if collected:
		return
	collected = true
	play_animation()	
	# sprites.hide()
	if body is Player:
		var player = body as Player
		player.inventory.add_mineral(mineral, 1)
	destroyParticle.emitting = true
	await destroyParticle.finished

	queue_free()
	pass # Replace with function body.

func play_animation() -> void:
	# var camera = get_tree().get_first_node_in_group("camera")
	# if camera == null:
	# 	return
	# var upper_left = camera.global_position - get_viewport_rect().size / 2

	# var tween = get_tree().create_tween()
	# var distance = sprite.global_position.distance_to(upper_left)
	# tween.tween_property(sprite, "global_position", upper_left, distance/speed_collect)
	# await tween.finished
	# queue_free()
	%AnimationPlayer.play("pop")
	await %AnimationPlayer.animation_finished
	sprite.hide()
	pass # Replace with function body.
