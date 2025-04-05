extends PlayerMovement
class_name PlayerBurrowedComponent

@export var acceleration: float = 600.0
@export var move_speed : float = 200.0
var current_direction: Vector2 = Vector2.ZERO
var last_input_vector: Vector2 = Vector2.ZERO

func set_current_direction(direction: Vector2) -> void:
	current_direction = direction

func physics_process(delta: float) -> void:
	var velocity = player.velocity
	var input_vector = get_input()

	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector

	current_direction = current_direction.move_toward(last_input_vector, acceleration * delta)
		# current_direction = input_vector.normalized()
	velocity = velocity.move_toward(current_direction * move_speed, acceleration * delta)

	player.velocity = velocity
	pass
