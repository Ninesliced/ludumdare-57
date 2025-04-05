extends Node2D
class_name CookingInterface

@onready var mouse_pin = $MouseAttractor

# Called when the node enters the scene tree for the first time.
func _ready():
	var ingredients = get_tree().get_nodes_in_group("ingredient")
	for ingredient in ingredients:
		_connect_ingredient(ingredient)

func _connect_ingredient(ingredient: Ingredient):
	ingredient.start_drag.connect(_on_ingredient_start_drag)
	ingredient.end_drag.connect(_on_ingredient_end_drag)

func _on_ingredient_start_drag(ingredient: Node2D):
	mouse_pin.node_b = ingredient.get_path()

func _on_ingredient_end_drag(_ingredient: Node2D):
	mouse_pin.node_b = NodePath("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
