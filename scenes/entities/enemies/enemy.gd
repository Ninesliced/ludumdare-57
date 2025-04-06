extends CharacterBody2D
class_name Enemy

var dead : bool = false

func _physics_process(delta: float) -> void:
    pass



func flip_h():
    if $AnimatedSprite2D.flip_h:
        $AnimatedSprite2D.flip_h = false
    else:
        $AnimatedSprite2D.flip_h = true

func _on_area_2d_body_entered(body:Node2D) -> void:
    if dead:
        return
    if body is Player:
        var player: Player = body
        if player.state_machine.current_state.name == "Grounded":
            body.remove_live("enemy")
        elif player.state_machine.current_state.name == "Burrowed":
            die()
        

    pass # Replace with function body.

func die():
    dead = true
    $StateMachine.set_physics_process(false)
    $StateMachine.set_process(false)
    $AnimationPlayer.play("die")

    print("die")
    await $AnimationPlayer.animation_finished
    queue_free()
