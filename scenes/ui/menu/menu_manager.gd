extends CanvasLayer
class_name MenuManager

var menu_stack: Array = []
var current_menu: Control = null
var can_back := true

@onready var background: Control = $Background
@onready var menus: Control = $Menus

const MENU_TRANSITION_DURATION = 0.3

# This is necessary because the "Back" notification is called twice on Android... for some reason...
var back_cooldown = 0.1
var back_cooldown_timer = 0.0


func _ready():
	pass

@export var texture: Texture:
	set(value):
		texture = value
		$Sprite2D.texture = texture 


func _process(delta):
	back_cooldown_timer = max(0.0, back_cooldown_timer - delta)


func pause():
	if not Global.can_pause:
		return

	# %PauseMenu.show()
	# set_menu("PauseMenu")


func exit_menu():
	# %PauseMenu.hide()

	# menu_stack = []
	Global.paused = false
	
	_animate_background(Color.TRANSPARENT, 0)
	var viewport_width = get_viewport().get_visible_rect().size.x
	if current_menu:
		_animate_menu(current_menu, Vector2.ZERO, Vector2(viewport_width, 0), true).tween_callback(hide)
	current_menu = null

	# hide()
	get_tree().set_pause(false)


func set_menu(menu_name: String, add_to_stack: bool = true, animation_direction_right = true):
	var menu: Control = get_node_or_null("Menus/" + str(menu_name))
	if not menu:
		return
	
	set_menu_by_node(menu, add_to_stack, animation_direction_right)


func set_menu_by_node(menu: Control, add_to_stack = true, animation_direction_right = true):
	if not menu:
		return

	Global.paused = true
	
	_animate_background(Color.WHITE, 3)

	show()
	get_tree().set_pause(true)
	
	for child in menus.get_children():
		if child != current_menu:
			child.hide()
	
	var viewport_width = get_viewport().get_visible_rect().size.x
	var animation_sign = 1 if animation_direction_right else -1
	if current_menu:
		_animate_menu(current_menu, Vector2.ZERO, Vector2(-viewport_width * animation_sign, 0), true)

	menu.show()
	_animate_menu(menu, Vector2(animation_sign * viewport_width, 0), Vector2(0, 0))

	current_menu = menu
	if add_to_stack:
		menu_stack.append(menu.name) 


func back():
	if not can_back:
		return
	if back_cooldown_timer > 0:
		return
	back_cooldown_timer = back_cooldown

	menu_stack.pop_back()
	if menu_stack.is_empty():
		exit_menu()
		return
	else:
		set_menu(menu_stack[-1], false, false)


# TODO on PC, key "escape" = back
func _input(event):	
	if event.is_action_pressed("pause"):
		if Global.paused:
			back()
		else:
			pause()


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		back()



func new_tween(node: Node, transition_type = Tween.TRANS_CUBIC, ease_type = Tween.EASE_IN_OUT) -> Tween:
	return get_tree().create_tween().bind_node(node).set_trans(transition_type).set_ease(ease_type)


func _animate_menu(menu: Node, initial_pos: Vector2, final_pos: Vector2, hide_afterwards = false) -> Tween:
	var tween = new_tween(menu)
	tween.tween_method(menu.set_position, initial_pos, final_pos, MENU_TRANSITION_DURATION)
	if hide_afterwards:
		tween.tween_callback(menu.hide)
	
	return tween


func _animate_background(color: Color, final_blur: float):
	var background_tween = new_tween(background).set_parallel(true)

	background_tween.tween_property(background, "modulate", color, MENU_TRANSITION_DURATION)
