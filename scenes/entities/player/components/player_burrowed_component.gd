extends PlayerMovement
class_name PlayerBurrowedComponent

@export var acceleration: float = 600.0
@export var rotation_speed: float = 5.0
@export var move_speed : float = 200.0
@export var mode : MovementMode = MovementMode.Directional
@export var bouncy: bool = true

enum MovementMode {
	Directional,
	Cardinal
}

var current_direction: Vector2 = Vector2.ZERO
var last_input_vector: Vector2 = Vector2.ZERO
var list_last_input_vector: Array = []

func set_current_direction(direction: Vector2) -> void:
	if mode == MovementMode.Cardinal:
		var angle = rad_to_deg(direction.angle())
		var roundedAngle = round(angle / 90) * 90
		angle = deg_to_rad(roundedAngle)
		direction = Vector2(cos(angle), sin(angle))
		last_input_vector = direction
	else:
		last_input_vector = direction
	
	current_direction = direction

func enter() -> void:
	list_last_input_vector.clear()

func physics_process(delta: float) -> void:
	var velocity = player.velocity
	
	if mode == MovementMode.Cardinal:
		handle_cardinal()
	elif mode == MovementMode.Directional:
		handle_directional()

	

	var angle = rotate_toward(current_direction.angle(), last_input_vector.angle(),rotation_speed * delta)
	current_direction = Vector2(cos(angle), sin(angle)).normalized()
	if current_direction != Vector2.ZERO:
		current_direction = current_direction.normalized()
	velocity = velocity.move_toward(current_direction * move_speed, acceleration * delta)

	player.velocity = velocity
	var collision = player.move_and_collide(player.velocity * delta)
	if bouncy and collision:
		player.velocity = velocity.bounce(collision.get_normal())
		current_direction = player.velocity.normalized()
	pass

func handle_directional():
	var input_vector = get_input()
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector

func handle_cardinal() -> void:
	var direction_mode = {
		"up": Vector2.UP,
		"down": Vector2.DOWN,
		"left": Vector2.LEFT,
		"right": Vector2.RIGHT
	}

	for direction in direction_mode.keys():
		if Input.is_action_just_pressed(direction):
			list_last_input_vector.append(direction_mode[direction])

		if Input.is_action_just_released(direction):
			list_last_input_vector.erase(direction_mode[direction])

	if list_last_input_vector.size() != 0:
		last_input_vector = list_last_input_vector[list_last_input_vector.size() - 1]
