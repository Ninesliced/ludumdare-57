extends Node2D

@export var body : CharacterBody2D = null
var goes_right: bool = true
var speed: float = 10.0
var gravity: float = 7.0
@onready var down_left: RayCast2D = %DownLeft
@onready var down_right: RayCast2D = %DownRight
@onready var left: RayCast2D = %Left
@onready var right: RayCast2D = %Right
 
func physics_process(delta: float) -> void:
	if !down_left.is_colliding() and !goes_right:
		print("flip")
		flip_direciton()

	if !down_right.is_colliding() and goes_right:
		print("flip2")
		flip_direciton()

	if left.is_colliding() and !right.is_colliding():
		print("flip3")
		if !goes_right:
			flip_direciton()
		goes_right = true

	if right.is_colliding() and !left.is_colliding():
		print("flip4")
		if goes_right:
			flip_direciton()
		goes_right = false

	body.velocity.y += gravity
	if body.is_on_floor():
		body.velocity.y = 0
	if goes_right:
		body.velocity.x = speed
	else:
		body.velocity.x = -speed
	
	# print(global_position)
	body.move_and_slide()

func flip_direciton():
	var enemy : Enemy = body
	goes_right = !goes_right
	enemy.flip_h()
