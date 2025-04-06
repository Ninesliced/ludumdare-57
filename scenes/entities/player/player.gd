extends CharacterBody2D
class_name Player

@onready var grounded_detector: GroundedDetector = %GroundedDetector
var inventory: Inventory = Global.inventory

var jump_requested: bool = false
var coyote_timer: Timer = null
@export var coyote_time: float = 0.1

var burrow_requested: bool = false
var burrow_timer: Timer = null
@export var burrow_time: float = 0.1

@export var hold_to_burrow: bool = false

@onready var state_machine: StateMachine = $StateMachine

const FALL_DAMAGE_VELLOCITY_Y = 400
const MAX_LIFE = 1

signal on_collide()

var life = MAX_LIFE:
	set(value):
		life = value
		life_update()
var velocity_before_collision : Vector2 = Vector2.ZERO
var inital_position;

var is_player_freeze = false

func _ready():
	_set_coyote()
	_set_burrow_buffer()
	inital_position = global_position
	pass

func _process(delta):
	if Input.is_action_just_pressed("burrow"):
		request_burrow()
		return
	if Input.is_action_just_released("burrow"):
		unrequest_burrow()
		return
	if Input.is_action_just_pressed("jump"):
		request_jump()
	pass

func _physics_process(delta):
	if !is_colliding_burrowable():
		velocity_before_collision = velocity
	var delta_vel = get_real_velocity()
	if(velocity_before_collision != Vector2(0.,0.) && delta_vel != Vector2(0.,0.)):
		if(velocity_before_collision.y > FALL_DAMAGE_VELLOCITY_Y && is_on_floor()):
			remove_live("fall")
			print("AIE degat chute")
	
	pass

func is_colliding_burrowable() -> bool: ## TEMPORARY
	var grounded_detector_collisioned = grounded_detector.is_grounded()
	# var player_collisioned = (is_on_floor() or is_on_wall() or is_on_ceiling())
	return grounded_detector_collisioned

func is_colling() -> bool:
	return is_on_floor() or is_on_wall() or is_on_ceiling()


func _set_burrow_buffer():
	burrow_timer = Timer.new()
	burrow_timer.wait_time = burrow_time
	burrow_timer.one_shot = true
	burrow_timer.timeout.connect(_disable_burrow)
	add_child(burrow_timer)

func request_burrow() -> void:
	burrow_requested = true
	if hold_to_burrow:
		return
	if not burrow_timer.is_stopped():
		burrow_timer.start()
	else:
		burrow_timer.stop()
		burrow_timer.start()

func unrequest_burrow() -> void:
	if hold_to_burrow:
		burrow_requested = false
		return
	# if burrow_timer.is_stopped():
	# 	burrow_timer.stop()
	# 	burrow_timer.start()

func _disable_burrow():
	burrow_timer.stop()
	burrow_requested = false

#### JUMP

func _set_coyote():
	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_disable_coyote)
	add_child(coyote_timer)

func request_jump() -> void:
	jump_requested = true
	if not coyote_timer.is_stopped():
		coyote_timer.start()
	else:
		coyote_timer.stop()
		coyote_timer.start()

func _disable_coyote():
	coyote_timer.stop()
	jump_requested = false
	
	
	
#### Les points de vies
var die_cause = ""
func remove_live(cause):
	print("mort")
	die_cause = cause
	life -= 1
	
func life_update():
	if (life <= 0):
		life = MAX_LIFE
		var dieSprite: AnimatedSprite2D = %dieSprite
		if dieSprite != null:
			dieSprite.visible = true
		
			dieSprite.play("die_fall" if die_cause == "fall" else "die_spike")
		is_player_freeze = true
		%PlayerSprite.visible = false


func _on_die_sprite_animation_finished():
	print("unfreeze")
	%PlayerSprite.visible = true
	var dieSprite: AnimatedSprite2D = %dieSprite
	is_player_freeze = false
	dieSprite.visible = false
	global_position = inital_position
	var MapLoader = get_tree().get_first_node_in_group("MapLoader")
	if(MapLoader):
		MapLoader.reset_map()
