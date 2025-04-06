extends Area2D

var touches_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$Label.text = str(touches_player)

func _input(event):
	if event.is_action_pressed("burrow") and touches_player:
		get_tree().change_scene_to_file("res://scenes/cooking/cooking_interface.tscn")


func _on_body_entered(body:Node2D):
	print(body)
	if body is Player:
		touches_player = true


func _on_body_exited(body:Node2D):
	if body is Player:
		touches_player = false
