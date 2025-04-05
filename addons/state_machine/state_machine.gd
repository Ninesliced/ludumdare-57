extends Node
class_name StateMachine
#TO DO , add player as init for all states
@export var initial_state : State
@export var entity : Node

var states : Dictionary = {}
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.entity = entity
			child.state_finished.connect(on_state_transition)
			
	if initial_state:
		current_state = initial_state
		current_state.enter()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
	pass

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physic_process(delta)

func on_state_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	if states.has(new_state_name):
		current_state = states[state.name.to_lower()]
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if state:
		state.exit()
	new_state.enter()
	new_state.state_enter.emit()
	current_state = new_state
	pass
