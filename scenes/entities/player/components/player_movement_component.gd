extends Node

class_name PlayerMovement

@export var player : Player = null

func physics_process(delta: float) -> void:
	pass


func get_input() -> Vector2:
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
	return input_vector.normalized()
