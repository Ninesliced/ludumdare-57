extends Node2D
class_name CookingInterface

@onready var mouse_pin = $MouseAttractor

var ingredient_prefab: PackedScene = preload("res://scenes/cooking/ingredient.tscn")

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


func add_ingredient(mineral_type: Ingredient.MineralType):
	var ingredient: Ingredient = ingredient_prefab.instantiate()
	ingredient.global_transform.origin = $IngredientSpawnLoc.global_position
	
	add_child(ingredient)

	ingredient.generate_type(mineral_type)
	_connect_ingredient(ingredient)
	


func _on_add_ruby_pressed():
	add_ingredient(Ingredient.MineralType.RUBY)

func _on_add_emerald_pressed():
	add_ingredient(Ingredient.MineralType.EMERALD)

func _on_add_topaz_pressed():
	add_ingredient(Ingredient.MineralType.TOPAZ)

func _on_add_diamond_pressed():
	add_ingredient(Ingredient.MineralType.DIAMOND)

func _on_add_amethyst_pressed():
	add_ingredient(Ingredient.MineralType.AMETHYST)
