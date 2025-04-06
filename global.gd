extends Node

var can_pause = true
var paused: bool = false

var menu_manager: MenuManager
var inventory: Inventory = Inventory.new()

var minerals_icon = {
	Inventory.Minerals.RUBY: preload("res://assets/images/particle/ruby.png"),
	Inventory.Minerals.EMERALD: preload("res:///assets/images/particle/emerald.png"),
	Inventory.Minerals.TOPAZ: preload("res:///assets/images/particle/topaz.png"),
	Inventory.Minerals.DIAMOND: preload("res:///assets/images/particle/diamond.png"),
	Inventory.Minerals.AMETHYST: preload("res:///assets/images/particle/amethyst.png")
}

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

func triangle_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return abs((a.x * (b.y - c.y) +
				b.x * (c.y - a.y) +
				c.x * (a.y - b.y)) / 2.0)

func area_of_polygon(polygon: PackedVector2Array):
	var triangles = Geometry2D.triangulate_polygon(polygon)

	var area = 0.0
	for i in range(0, triangles.size(), 3):
		area += triangle_area(polygon[triangles[i]], polygon[triangles[i+1]], polygon[triangles[i+2]])
	
	return area
