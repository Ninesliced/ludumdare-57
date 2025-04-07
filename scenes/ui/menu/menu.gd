extends Control
class_name Menu

@onready var menu_manager: MenuManager = get_parent().get_parent()

func _on_back_button_pressed():
	menu_manager.back()


func _on_quit_pressed():
	Global.save_inventory()
	get_tree().quit()

func _on_resume_pressed():
	Global.menu_manager.back()