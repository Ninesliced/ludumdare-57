extends CanvasLayer

var player : Player

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	player = players[0]
	var inventory = player.inventory as Inventory
	update_text_icon()

	inventory.inventory_changed.connect(update_text_icon)

func _process(delta):
	%MoneyCounter.text = "€" + str(Global.money)

func update_text_icon():
	var inventory = player.inventory as Inventory
	var minerals = inventory.minerals

	%Ruby.set_icon_text(Global.minerals_icon[Inventory.Minerals.RUBY], minerals[Inventory.Minerals.RUBY])
	%Emerald.set_icon_text(Global.minerals_icon[Inventory.Minerals.EMERALD], minerals[Inventory.Minerals.EMERALD])
	%Topaz.set_icon_text(Global.minerals_icon[Inventory.Minerals.TOPAZ], minerals[Inventory.Minerals.TOPAZ])
	%Diamond.set_icon_text(Global.minerals_icon[Inventory.Minerals.DIAMOND], minerals[Inventory.Minerals.DIAMOND])
	%Amethyst.set_icon_text(Global.minerals_icon[Inventory.Minerals.AMETHYST], minerals[Inventory.Minerals.AMETHYST])
	
