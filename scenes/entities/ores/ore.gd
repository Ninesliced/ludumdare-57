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
	
	sprite.hide()
	if body is Player:
		var player = body as Player
		player.inventory.add_mineral(mineral, 1)
	destroyParticle.emitting = true
	await destroyParticle.finished

	queue_free()
	pass # Replace with function body.
