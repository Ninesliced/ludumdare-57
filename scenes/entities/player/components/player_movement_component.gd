extends Node

@export var player : Player = null

@export var move_speed: float = 80.0
@export var acceleration: float = 80 * 12
@export var deceleration: float = 80 * 12

@export var jump_height: float = 24.0
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.3


var jump_requested: bool = false
var coyote_timer: Timer = null
@export var coyote_time: float = 0.1


@onready var jump_velocity: float = -(2.0 * jump_height) / jump_time_to_peak 
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)



var gravity_enabled: bool = true

func _ready() -> void:
	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(disable_coyote)
	add_child(coyote_timer)

func _physics_process(delta: float) -> void:
	var velocity = player.velocity

	
	velocity.x = handle_movement(velocity, delta)
	if gravity_enabled:
		velocity.y -= get_gravity(velocity) * delta

	if Input.is_action_just_pressed("jump"):
		request_jump()
	if jump_requested and player.is_on_floor():
		velocity.y = jump(velocity)

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y = velocity.y * 0.5

	player.velocity = velocity
	

func get_gravity(velocity) -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

## JUMP functionnality

func request_jump() -> void:
	jump_requested = true
	if not coyote_timer.is_stopped():
		coyote_timer.start()
	else:
		coyote_timer.stop()
		coyote_timer.start()

func jump(velocity: Vector2) -> float:
	velocity.y = jump_velocity
	return velocity.y

func disable_coyote():
	coyote_timer.stop()
	jump_requested = false
	

func handle_movement(velocity: Vector2, delta: float) -> float:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("left", "right")
	if input_vector.x != 0:
		velocity.x = velocity.move_toward(input_vector * move_speed, acceleration * delta).x
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO, deceleration * delta).x
	return velocity.x
