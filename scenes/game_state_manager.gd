extends Node2D
var timer : Timer
var money_needed : int = 400
var money_multiplier : float = 1.2

var days : int = 0

func _ready() -> void:
    start_timer()

func start_timer():
    timer = Timer.new()
    timer.wait_time = 120
    timer.one_shot = false
    timer.timeout.connect(_on_timeout)
    add_child(timer)
    timer.start()


func _on_timeout():
    Global.money -= money_needed
    if Global.money < 0:
        restart_game()
        return
    money_needed = money_needed * money_multiplier
    days += 1


func restart_game():
    get_tree().reload_current_scene()
    Global.inventory = Inventory.new()
    Global.money = 0

func get_time_left():
    return timer.time_left