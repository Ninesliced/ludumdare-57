extends Node2D

class_name Ore

var collected : bool = false
@onready var destroyParticle : CPUParticles2D = %DestroyParticle
@onready var sprite: AnimatedSprite2D = %Sprite2D

func _on_area_2d_body_entered(body:Node2D) -> void:
	if collected:
		return
	collected = true
	
	sprite.hide()
	destroyParticle.emitting = true
	await destroyParticle.finished
	queue_free()
	pass # Replace with function body.
