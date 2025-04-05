extends RigidBody2D
class_name Ingredient

signal start_drag(ingredient: Node2D)
signal end_drag(ingredient: Node2D)

@export var drag_spring_force := 30000.0

var dragged := false
var drag_offset := Vector2.ZERO

func _ready():
	pass


func _process(delta):
	pass

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
