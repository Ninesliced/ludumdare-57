extends Area2D

class_name GroundedDetector

var number_grounded: int = 0
var _is_grounded: bool = false

func is_grounded() -> bool:
	return _is_grounded


func _on_body_entered(body:Node2D) -> void:
	number_grounded += 1
	if number_grounded > 0:
		_is_grounded = true
	pass # Replace with function body.


func _on_body_exited(body:Node2D) -> void:
	number_grounded -= 1
	if number_grounded <= 0:
		_is_grounded = false
	pass # Replace with function body.
