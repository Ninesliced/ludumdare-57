extends Node

var can_pause = true
var paused: bool = false

var menu_manager: MenuManager

@onready var menu_manager_scene = preload("res://scenes/ui/menu/menu_manager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_manager = menu_manager_scene.instantiate()
	add_child(menu_manager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	pass
