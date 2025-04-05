extends State

@export var playerBurrowedComponent: PlayerBurrowedComponent = null
@export var collisionShape: CollisionShape2D = null
@export var groundedDetector : GroundedDetector = null

var direction: Vector2 = Vector2.ZERO

func enter():
	if !entity is Player:
		print("error: entity is not a Player")
		return
	var player = entity as Player
	direction = player.velocity
	direction = direction.normalized()

	var angle = rad_to_deg(direction.angle())
	var roundedAngle = round(angle / 45) * 45
	angle = deg_to_rad(roundedAngle)
	direction = Vector2(cos(angle), sin(angle))

	playerBurrowedComponent.last_input_vector = direction

	player.collision_mask = 2
	print("keep keep_velocity")
	player.velocity = player.velocity_before_collision
	print(player.velocity)
	pass


func physic_process(delta: float) -> void:
	playerBurrowedComponent.physics_process(delta)
	if (not groundedDetector.is_grounded()):
		emit_signal("state_finished", self, "grounded")
		return
	pass
