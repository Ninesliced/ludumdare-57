extends State

@export var exit_force: float = 0

@export var playerBurrowedComponent: PlayerBurrowedComponent = null
@export var collisionShape: CollisionShape2D = null
@export var groundedDetector : GroundedDetector = null

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
	pass


func physic_process(delta: float) -> void:
	playerBurrowedComponent.physics_process(delta)
	if (not groundedDetector.is_grounded()):
		var player = entity as Player
		if player.burrow_requested:#entity.jump_requested:
			print("release")
			entity.velocity *= exit_force
		emit_signal("state_finished", self, "grounded")
		return
	pass

func exit():
	burrowParticle.emitting = false
	pass

func apply_direction(player):
	direction = player.velocity
	direction = direction.normalized()

	var angle = rad_to_deg(direction.angle())
	var roundedAngle = round(angle / 45) * 45
	angle = deg_to_rad(roundedAngle)
	direction = Vector2(cos(angle), sin(angle))

	playerBurrowedComponent.last_input_vector = direction
