extends Resource
class_name Inventory
const NB_MINERAL = 5

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
