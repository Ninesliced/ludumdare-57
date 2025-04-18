extends State

@export var jump_force: float = 0
@export var hold_to_jump: bool = false
@export var playerBurrowedComponent: PlayerBurrowedComponent = null
@export var collisionShape: CollisionShape2D = null
@export var groundedDetector : GroundedDetector = null
@export var staminaComponent : StaminaComponent = null
@export var sprite : AnimatedSprite2D = null

@onready var burrowParticle : CPUParticles2D = %BurrowParticle


var direction: Vector2 = Vector2.ZERO

func enter():
	if !entity is Player:
		return
	var player = entity as Player

	apply_direction(player)
	burrowParticle.emitting = true
	player.collision_mask = 1
	player.velocity = player.velocity_before_collision.normalized() * playerBurrowedComponent.move_speed
	playerBurrowedComponent.set_current_direction(player.velocity.normalized())
	playerBurrowedComponent.enter()

	sprite.play("burrowing")
	$BurrowSound.play()


func physic_process(delta: float) -> void:
	staminaComponent.consume_stamina(staminaComponent.stamina_cost * delta)
	playerBurrowedComponent.physics_process(delta)
	if (not groundedDetector.is_grounded()):
		var player = entity as Player

		
		if !hold_to_jump or (player.burrow_requested or player.jump_requested):
			entity.velocity *= jump_force
		else:
			entity.velocity *= 0.1
		emit_signal("state_finished", self, "grounded")
		return
	pass

func exit():
	burrowParticle.emitting = false
	$BurrowSound.stop()

func apply_direction(player):
	direction = player.velocity
	direction = direction.normalized()

	var angle = rad_to_deg(direction.angle())
	var roundedAngle = round(angle / 45) * 45
	angle = deg_to_rad(roundedAngle)
	direction = Vector2(cos(angle), sin(angle))

	playerBurrowedComponent.last_input_vector = direction
	
