extends TileMapLayer

var required_money : int = 300
var opened : bool = false
func _ready() -> void:
    close_gate()
    GameState.timer.timeout.connect(_on_timeout)
    pass

func _process(delta: float) -> void:
    pass

func open_gate():
    collision_enabled = false
    hide()
    if GameState:
        GameState.timer.start()
        GameState.door_opened = true
    opened = true

func close_gate():
    collision_enabled = true
    show()
    opened = false

func _on_timeout():
    close_gate()

    pass

func _on_area_2d_body_entered(body:Node2D) -> void:
    if body.is_in_group("player") and collision_enabled and not opened:
        Global.money -= required_money
        open_gate()
    
    pass # Replace with function body.
