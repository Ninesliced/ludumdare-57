extends Node

class_name State

var entity : Node
signal state_finished
signal state_enter

func enter() -> void:
	pass

func process(delta: float) -> void:
	pass

func physic_process(delta: float) -> void:
	pass

func exit() -> void:
	pass