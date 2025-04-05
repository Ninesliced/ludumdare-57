extends Node2D
class_name CookingInterface

@onready var mouse_pin = $MouseAttractor

var ingredient_prefab: PackedScene = preload("res://scenes/cooking/ingredient.tscn")

var bounds: Rect2
const SELECTION_PADDING = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	var ingredients = get_tree().get_nodes_in_group("ingredient")
	for ingredient in ingredients:
		_connect_ingredient(ingredient)
	
	var x1 = %CollisionShapeLeft.global_position.x
	var x2 = %CollisionShapeRight.global_position.x
	var y1 = %CollisionShapeTop.global_position.y
	var y2 = %CollisionShapeBottom.global_position.y
	bounds = Rect2(x1, y1, x2-x1, y2-y1)


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

func _physics_process(delta):
	var padded_bounds = Rect2(bounds.position + Vector2.ONE * SELECTION_PADDING, bounds.size - Vector2.ONE * SELECTION_PADDING*2)

	var mouse_pos = get_global_mouse_position()
	mouse_pin.global_transform.origin = Vector2(
		clamp(mouse_pos.x, padded_bounds.position.x, padded_bounds.end.x),
		clamp(mouse_pos.y, padded_bounds.position.y, padded_bounds.end.y)
	)
	# padded_rect. 


func add_ingredient_node(ingredient: Ingredient):
	add_child(ingredient)
	_connect_ingredient(ingredient)


func add_ingredient(mineral_type: Ingredient.MineralType):
	var ingredient: Ingredient = ingredient_prefab.instantiate()
	ingredient.global_transform.origin = $IngredientSpawnLoc.global_position

	add_ingredient_node(ingredient)	

	ingredient.generate_type(mineral_type)


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
