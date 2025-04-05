extends Resource
class_name Inventory
const NB_MINERAL = 5

signal inventory_changed

enum Minerals 
{
    RUBY = 0,
    EMERALD = 1,
    TOPAZ = 2,
    DIAMOND = 3,
    AMETHYST = 4
}

@export var minerals: Dictionary[Minerals, int] = {
    Minerals.RUBY: 0,
    Minerals.EMERALD: 0,
    Minerals.TOPAZ: 0,
    Minerals.DIAMOND: 0,
    Minerals.AMETHYST: 0
}

func add_mineral(mineral: Minerals, amount: int) -> void:
    if mineral in minerals:
        minerals[mineral] += amount
        emit_signal("inventory_changed")
    else:
        push_error("Invalid mineral type.")

func remove_mineral(mineral: Minerals, amount: int) -> void:
    if mineral in minerals:
        if minerals[mineral] >= amount:
            minerals[mineral] -= amount
            emit_signal("inventory_changed")
        else:
            push_error("Not enough minerals to remove.")
    else:
        push_error("Invalid mineral type.")