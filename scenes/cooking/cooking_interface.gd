extends Node2D
class_name CookingInterface

signal start_slicing
signal end_slicing

@export_category("Slicing")
@export var knife_width = 2.0

@onready var mouse_pin = $MouseAttractor
@onready var knife_preview: Line2D = $KnifePreview
@onready var plus_preview: Polygon2D = $PlusPreview
@onready var minus_preview: Polygon2D = $MinusPreview

var ingredient_prefab: PackedScene = preload("res://scenes/cooking/ingredient.tscn")

var bounds: Rect2
const SELECTION_PADDING = 2

var is_slicing = false
var slice_start: Vector2

var ref_shapes_scene = preload("res://scenes/cooking/ref_shapes.tscn")
var ref_shapes = []
var ref_shape: Polygon2D = null
@onready var ref_line = $RefLine

var rng = RandomNumberGenerator.new()

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

	knife_preview.hide()
	knife_preview.points = PackedVector2Array([Vector2.ZERO, Vector2.ZERO])

	_load_ref_shapes()
	_set_ref_shape(rng.randi_range(0, ref_shapes.size()-1))


func _connect_ingredient(ingredient: Ingredient):
	ingredient.start_drag.connect(_on_ingredient_start_drag)
	ingredient.end_drag.connect(_on_ingredient_end_drag)

func _on_ingredient_start_drag(ingredient: Node2D):
	mouse_pin.node_b = ingredient.get_path()

func _on_ingredient_end_drag(_ingredient: Node2D):
	mouse_pin.node_b = NodePath("")


func _on_start_slicing():
	is_slicing = true
	knife_preview.show()

	slice_start = get_global_mouse_position()
	knife_preview.points[0] = slice_start


func _on_end_slicing():
	is_slicing = false
	knife_preview.hide()

	var ingredients = get_tree().get_nodes_in_group("ingredient")
	for ing in ingredients:
		ing.slice(slice_start, get_global_mouse_position(), knife_width)
	

##################################################################


func _input(event):
	if event.is_action_pressed("right_click"):
		start_slicing.emit()
	if event.is_action_released("right_click"):
		end_slicing.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_slicing:
		var mouse_pos = get_global_mouse_position()
		knife_preview.points[1] = mouse_pos


func _physics_process(delta):
	var padded_bounds = Rect2(bounds.position + Vector2.ONE * SELECTION_PADDING, bounds.size - Vector2.ONE * SELECTION_PADDING*2)

	var mouse_pos = get_global_mouse_position()
	mouse_pin.global_transform.origin = Vector2(
		clamp(mouse_pos.x, padded_bounds.position.x, padded_bounds.end.x),
		clamp(mouse_pos.y, padded_bounds.position.y, padded_bounds.end.y)
	)

	ref_line.points = ref_shape.polygon
	_calculate_shape_score()

	# padded_rect. 
func _load_ref_shapes():
	var ref_shapes_node: Node2D = ref_shapes_scene.instantiate()
	ref_shapes_node.position = Vector2(0, -20000)
	add_child(ref_shapes_node)

	ref_shapes = []

	for shape in ref_shapes_node.get_children():
		ref_shapes.append(shape)

func _set_ref_shape(shape_index):
	ref_shape = ref_shapes[shape_index]
	ref_shape.global_position.x = $RefShapeLoc.position.x
	ref_shape.global_position.y = $RefShapeLoc.global_position.y + ref_shape.position.y

	add_child(ref_shape)

	ref_shape.hide()
	ref_line.global_transform = ref_shape.global_transform
	ref_line.points = ref_shape.polygon

func _calculate_shape_score():
	var ingredients = get_tree().get_nodes_in_group("ingredient")

	if ingredients.is_empty():
		return

	var score = 0.0
	for ing in ingredients:
		ing.set_outline(false)
		
		var ref_shape_translated = ref_shape.global_transform * ref_shape.polygon
		var ing_shape_translated = ing.global_transform * ing.shape

		var inter = Geometry2D.intersect_polygons(ref_shape_translated, ing_shape_translated) 
		if inter.is_empty():
			continue

		var diff = Geometry2D.clip_polygons(ing_shape_translated, ref_shape_translated) 

		score += Global.area_of_polygons(inter)
		score -= Global.area_of_polygons(diff)

		ing.set_outline(true)

	var ref_area = Global.area_of_polygon(ref_shape.polygon)
	$DebugLabel.text = str(score / ref_area)


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
