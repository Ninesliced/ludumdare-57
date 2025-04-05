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

func update_text_icon():
	var inventory = player.inventory as Inventory
	var minerals = inventory.minerals

	%Ruby.set_icon_text(Global.minerals_icon[Inventory.Minerals.RUBY], "0")
	%Emerald.set_icon_text(Global.minerals_icon[Inventory.Minerals.EMERALD], "0")
	%Topaz.set_icon_text(Global.minerals_icon[Inventory.Minerals.TOPAZ], "0")
	%Diamond.set_icon_text(Global.minerals_icon[Inventory.Minerals.DIAMOND], "0")
	%Amethyst.set_icon_text(Global.minerals_icon[Inventory.Minerals.AMETHYST], "0")
	
