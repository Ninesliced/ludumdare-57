extends Node2D

var particles : Array[CPUParticles2D] = []
var queue_num : int = 0
func _ready():
	for node in get_children():
		if node is CPUParticles2D:
			particles.append(node)
	queue_num = particles.size()
	for particle in particles:
		particle.finished.connect(decrement_queue)
	pass

func play():
	reparent(get_tree().current_scene)
	for particle in particles:
		particle.emitting = true

func decrement_queue():
	queue_num -= 1
	if queue_num <= 0:
		queue_num = particles.size()
		for particle in particles:
			particle.emitting = false
		print("free")
		queue_free()
	pass
