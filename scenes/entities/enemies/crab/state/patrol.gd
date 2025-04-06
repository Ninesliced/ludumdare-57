extends State

@export var linearMovementComponent : Node2D

func physic_process(delta: float) -> void:
	linearMovementComponent.physics_process(delta)
	pass
