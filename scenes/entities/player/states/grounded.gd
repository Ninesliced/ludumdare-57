extends State

class_name GroundedState

@export var player : Player = null
@export var playerGroundMovement : PlayerGroundMovement = null

func enter() -> void:
    pass

func process(delta: float) -> void:
    pass

func physic_process(delta: float) -> void:
    playerGroundMovement.physics_process(delta)
    pass