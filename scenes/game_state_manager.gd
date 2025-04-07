extends Node2D
var timer : Timer
var money_needed : int = 300
var door_opened : bool = false
# var money_multiplier : float = 1.2

var days : int = 0

func _ready() -> void:
    print("starting")
    start_timer()

func start_timer():
    print("test")
    timer = Timer.new()
    timer.wait_time = 60 * 3
    timer.one_shot = true
    timer.timeout.connect(_on_timeout)
    add_child(timer)
    timer.start()


func _on_timeout():
    door_opened = false
    days += 1


func restart_game():
    get_tree().reload_current_scene()
    Global.inventory = Inventory.new()
    Global.money = 0

func get_time_left():
    return timer.time_left