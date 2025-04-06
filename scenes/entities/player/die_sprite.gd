extends AnimatedSprite2D

func die_animation(cause):
	print("hi")
	play("die_fall")
	get_tree().paused = true
	print("still_running")


func _on_animation_finished():
	print("end")
	get_tree().paused = false
