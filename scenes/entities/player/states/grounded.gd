extends State

class_name GroundedState

@export var player : Player = null
@export var playerGroundMovement : PlayerGroundMovement = null

func enter() -> void:
	entity.collision_mask = 3
	pass

func process(delta: float) -> void:
	pass

func physic_process(delta: float) -> void:
	playerGroundMovement.physics_process(delta)
	if player.burrow_requested and player.is_colliding():
		emit_signal("state_finished", self, "burrowed")
		return
	pass
