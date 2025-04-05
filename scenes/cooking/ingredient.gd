extends RigidBody2D
class_name Ingredient

signal start_drag(ingredient: Node2D)
signal end_drag(ingredient: Node2D)

enum MineralType {
	RUBY,
	EMERALD,
	TOPAZ,
	DIAMOND,
	AMETHYST
}

@export var drag_spring_force := 30000
@export var texture: Texture2D:
	set(value):
		texture = value
		$Polygon2D.texture = value 

@export_category("Polygon")
@export var min_angle_step := TAU*0.05
@export var max_angle_step := TAU*0.2
@export var min_radius := 10
@export var max_radius := 30

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision_shape: CollisionPolygon2D = $CollisionPolygon2D

var dragged := false
var drag_offset := Vector2.ZERO

var _rng = RandomNumberGenerator.new()

var texture_ruby = preload("res://assets/images/textures/ruby_texture.png")
var texture_emerald = preload("res://assets/images/textures/emerald_texture.png")
var texture_topaz = preload("res://assets/images/textures/topaz_texture.png")
var texture_diamond = preload("res://assets/images/textures/diamond_texture.png")
var texture_amethyst = preload("res://assets/images/textures/amethyst_texture.png")

func _ready():
	if texture:
		$Polygon2D.texture = texture 

func _process(delta):
	pass

func _get_random_shape():
	var points = []

	var angles = []
	var angle = 0
	while angle <= TAU - max_angle_step:
		angles.append(angle)

		var step = _rng.randf_range(min_angle_step, max_angle_step)
		angle += step

	angles.sort()

	for i in range(angles.size()):
		var rad = _rng.randf_range(min_radius, max_radius)
		points.append(Vector2.from_angle(angles[i]) * rad)

	return points

func _generate_shape():
	var points = _get_random_shape()
	polygon.polygon = PackedVector2Array(points)
	collision_shape.polygon = PackedVector2Array(points)


func _convert_shape_to_concave(points):
	if points.is_empty():
		return []

	var out = [points[0]]
	for i in range(1, points.size()-1):
		out.append(points[i])
		out.append(points[i+1])	
	out.append(points[points.size()-1])

	return out


func _physics_process(delta):
	pass
	# if dragged:
	# 	var force = get_global_mouse_position() + drag_offset - global_transform.origin
	# 	apply_central_force(drag_spring_force * force * delta)


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

func generate_type(mineral_type: MineralType):
	if mineral_type == MineralType.RUBY:
		texture = texture_ruby
		min_angle_step = TAU/8 - 0.03	
		max_angle_step = TAU/8 - 0.01
		min_radius = 20
		max_radius = 24	

	if mineral_type == MineralType.EMERALD:
		texture = texture_emerald
		min_angle_step = TAU*0.05	
		max_angle_step = TAU*0.1
		min_radius = 10
		max_radius = 20

	if mineral_type == MineralType.TOPAZ:
		texture = texture_topaz
		min_angle_step = TAU/6-0.01	
		max_angle_step = TAU/6-0.01
		min_radius = 15
		max_radius = 17

	if mineral_type == MineralType.DIAMOND:
		texture = texture_diamond
		min_angle_step = TAU*0.02	
		max_angle_step = TAU*0.2
		min_radius = 10
		max_radius = 15

	if mineral_type == MineralType.AMETHYST:
		texture = texture_amethyst
		min_angle_step = TAU*0.01	
		max_angle_step = TAU*0.2
		min_radius = 10
		max_radius = 40

	_generate_shape()
