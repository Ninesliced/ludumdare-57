extends RigidBody2D
class_name Ingredient

signal start_drag(ingredient: Node2D)
signal end_drag(ingredient: Node2D)

@export var drag_spring_force := 30000

@export_category("Polygon")
@export var min_points := 3
@export var max_points := 8
@export var min_radius := 20
@export var max_radius := 40

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var dragged := false
var drag_offset := Vector2.ZERO

var _rng = RandomNumberGenerator.new()

func _ready():
	_generate_shape()

func _process(delta):
	pass

func _get_random_shape():
	var points = []
	var nb_points = _rng.randi_range(min_points, max_points)

	var angles = []
	for i in range(nb_points):
		angles.append(_rng.randf_range(0, TAU))
	angles.sort()

	for i in range(nb_points):
		var rad = _rng.randf_range(min_radius, max_radius)
		points.append(Vector2.from_angle(angles[i]) * rad)

	return PackedVector2Array(points)

func _generate_shape():
	var shape = _get_random_shape()
	polygon.polygon = shape
	collision_shape.shape.points = shape


func _physics_process(delta):
	if dragged:
		var force = get_global_mouse_position() + drag_offset - global_transform.origin
		apply_central_force(drag_spring_force * force * delta)


func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			drag_offset = global_transform.origin - get_global_mouse_position()
			start_drag.emit(self)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			end_drag.emit(self)

func _on_start_drag():
	dragged = true
	# freeze = true

func _on_end_drag():
	dragged = false
	# freeze = false
