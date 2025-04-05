extends CharacterBody2D
class_name Player

var jump_requested: bool = false
var coyote_timer: Timer = null
@export var coyote_time: float = 0.1

func _ready():
    coyote_timer = Timer.new()
    coyote_timer.wait_time = coyote_time
    coyote_timer.one_shot = true
    coyote_timer.timeout.connect(disable_coyote)
    add_child(coyote_timer)
    pass

func _process(delta):
    pass

func _physics_process(delta):
    move_and_slide()
    pass


func request_jump() -> void:
    jump_requested = true
    if not coyote_timer.is_stopped():
        coyote_timer.start()
    else:
        coyote_timer.stop()
        coyote_timer.start()

func disable_coyote():
    coyote_timer.stop()
    jump_requested = false