extends State

class_name GroundedState

@export var player : Player = null
@export var playerGroundMovement : PlayerGroundMovement = null
@export var staminaComponent : StaminaComponent = null
@export var sprite: AnimatedSprite2D = null

@export_category("Animation")
@export var min_run_speed_animation = 40.0

var look_direction = false
var sprite_animation = "idle"

func enter() -> void:
	entity.collision_mask = 3

func process(delta: float) -> void:
	staminaComponent.recover_stamina(staminaComponent.stamina_recovery_rate * delta)

func physic_process(delta: float) -> void:
	_update_sprite()

	playerGroundMovement.physics_process(delta)

	if player.burrow_requested and \
		player.is_colliding_burrowable() and \
		staminaComponent.can_consume_stamina(staminaComponent.stamina_on_use_cost):

		staminaComponent.consume_stamina(staminaComponent.stamina_on_use_cost)
		emit_signal("state_finished", self, "burrowed")
		return


func _update_sprite():
	if abs(player.velocity.x) > min_run_speed_animation:
		look_direction = player.velocity.x < 0
		sprite.flip_h = look_direction
	
	if player.is_on_floor():
		if abs(player.velocity.x) > min_run_speed_animation:
			sprite_animation = "walk"
		else:
			sprite_animation = "idle"
	else:
		sprite_animation = "jump"
	
	sprite.play(sprite_animation)

func _on_player_ground_movement_component_jumped():
	# $JumpSound.play()
	$JumpVoiceSound.play()


func _on_player_sprite_animation_looped():
	if sprite_animation == "walk":
		$FootstepSoundDirt.play()
