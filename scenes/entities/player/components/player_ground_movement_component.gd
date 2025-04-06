extends PlayerMovement

class_name PlayerGroundMovement

var _enable_movement: bool = true

@export var move_speed: float = 80.0
@export var acceleration: float = 80 * 12
@export var deceleration: float = 80 * 12

@export var air_decceleration: float = 80*12

var _current_decceleration: float = 0

@export var jump_height: float = 24.0
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.3

@onready var jump_velocity: float = -(2.0 * jump_height) / jump_time_to_peak 
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)



var gravity_enabled: bool = true

func _ready() -> void:
	pass
func enter() -> void:
	pass
func set_enable_movement(enable: bool) -> void:
	_enable_movement = enable

func physics_process(delta: float) -> void:
	if player.is_on_floor():
		_current_decceleration = deceleration
	else:
		_current_decceleration = air_decceleration
	if not _enable_movement:
		return
	var velocity = player.velocity

	
	velocity.x = _handle_movement(velocity, delta)
	if gravity_enabled:
		velocity.y -= get_gravity(velocity) * delta

	if player.jump_requested and player.is_on_floor():
		velocity.y = _jump(velocity)

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y = velocity.y * 0.5

	player.velocity = velocity
	player.move_and_slide()




func get_gravity(velocity) -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

## JUMP functionnality

func _jump(velocity: Vector2) -> float:
	velocity.y = jump_velocity
	return velocity.y

	

func _handle_movement(velocity: Vector2, delta: float) -> float:
	var input_vector = get_input()
	if input_vector.x != 0:
		if abs(input_vector.x * move_speed) > abs(velocity.x) or velocity.x * input_vector.x < 0:
			velocity.x = velocity.move_toward(input_vector * move_speed, acceleration * delta).x
	else:
		var selected_deceleration = _current_decceleration
		velocity.x = velocity.move_toward(Vector2.ZERO, selected_deceleration * delta).x
	return velocity.x
