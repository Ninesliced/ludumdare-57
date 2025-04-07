extends Node

const GAME_DATA_SAVE_PATH = "user://data.tres"
const INVENTORY_VERSION = 2

var can_pause = true
var paused: bool = false

var menu_manager: MenuManager
var inventory: Inventory = Inventory.new()
var game_data: GameData = GameData.new()

var minerals_icon = {
	Inventory.Minerals.RUBY: preload("res://assets/images/particle/ruby.png"),
	Inventory.Minerals.EMERALD: preload("res:///assets/images/particle/emerald.png"),
	Inventory.Minerals.TOPAZ: preload("res:///assets/images/particle/topaz.png"),
	Inventory.Minerals.DIAMOND: preload("res:///assets/images/particle/diamond.png"),
	Inventory.Minerals.AMETHYST: preload("res:///assets/images/particle/amethyst.png")
}

@onready var menu_manager_scene = preload("res://scenes/ui/menu/menu_manager.tscn")

var money = 0
@onready var autosave_timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	menu_manager = menu_manager_scene.instantiate()
	add_child(menu_manager)
	autosave_timer.wait_time = 60
	autosave_timer.timeout.connect(_on_autosave_timeout)
	autosave_timer.one_shot = false
	add_child(autosave_timer)
	autosave_timer.start()
	
	if FileAccess.file_exists(GAME_DATA_SAVE_PATH):
		load_inventory()
	else:
		save_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return


func save_inventory():
	game_data.inventory = inventory
	game_data.money = money

	var result = ResourceSaver.save(game_data, GAME_DATA_SAVE_PATH)
	print("Data saved to " + GAME_DATA_SAVE_PATH + " with result: ", result)

func load_inventory():
	print("Loading inventory...")
	var loaded_data: GameData = ResourceLoader.load(GAME_DATA_SAVE_PATH) 

	money = loaded_data.money
	
	var loaded_inventory = loaded_data.inventory
	if loaded_inventory is Inventory:
		print(loaded_inventory.minerals)
		inventory = loaded_inventory
		var player : Player = get_tree().get_first_node_in_group("player")
		if player:
			player.inventory = inventory
	else:
		print("Failed to load data.")
	
func _on_autosave_timeout():
	print("Autosaving...")
	save_inventory()

func add_money(val):
	money += val



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

func area_of_polygons(polygons: Array[PackedVector2Array]):
	var sum = 0.0
	for p in polygons:
		sum += area_of_polygon(p)
	return sum


func get_polygon_center_of_mass(_polygon: PackedVector2Array) -> Vector2:
	var area = 0.0
	var centroid = Vector2()

	var n = _polygon.size()
	if n < 3:
		return Vector2()  # Not a polygon

	for i in range(n):
		var current = _polygon[i]
		var next = _polygon[(i + 1) % n]
		var cross = current.x * next.y - next.x * current.y
		area += cross
		centroid += (current + next) * cross

	area *= 0.5
	if area == 0.0:
		return Vector2()  # Degenerate polygon

	centroid /= (6.0 * area)
	return centroid

func polygons_to_merged_and_indexed(polygons: Array[PackedVector2Array]):
	var merged = PackedVector2Array()
	var indexed = []

	var i_point = 0
	var i_poly = 0
	for poly in polygons:
		indexed.append(PackedInt32Array([]))

		for point in poly:
			merged.append(point)
			indexed[i_poly].append(i_point)

			i_point += 1
		i_poly += 1
	
	return [merged, indexed]
