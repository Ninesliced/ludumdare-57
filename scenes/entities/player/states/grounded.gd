extends State

class_name GroundedState

@export var player : Player = null
@export var playerGroundMovement : PlayerGroundMovement = null
@export var staminaComponent : StaminaComponent = null
func enter() -> void:
	entity.collision_mask = 3

func process(delta: float) -> void:
	staminaComponent.recover_stamina(staminaComponent.stamina_recovery_rate * delta)

func physic_process(delta: float) -> void:
	playerGroundMovement.physics_process(delta)

	if player.burrow_requested and \
		player.is_colliding_burrowable() and \
		staminaComponent.can_consume_stamina(staminaComponent.stamina_on_use_cost):

		staminaComponent.consume_stamina(staminaComponent.stamina_on_use_cost)
		emit_signal("state_finished", self, "burrowed")
		return
