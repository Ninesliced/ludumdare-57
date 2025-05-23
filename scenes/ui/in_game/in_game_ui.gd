extends CanvasLayer

var player : Player

var euro_icon = preload("res:///assets/images/particle/euro.png")

func _ready():
	%Win.hide()
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	player = players[0]
	var inventory = player.inventory as Inventory
	update_text_icon()

	inventory.inventory_changed.connect(update_text_icon)

func _process(delta):
	%TimeLeft.text = str(int(GameState.get_time_left())) + "s"
	%MoneyNeeded.text = " need €" + str(3000)
	if Global.money >= 3000:
		%Win.show()

func update_text_icon():
	var inventory = player.inventory as Inventory
	var minerals = inventory.minerals

	%MoneyCounter.set_icon_text(euro_icon, Global.money)
	%Ruby.set_icon_text(Global.minerals_icon[Inventory.Minerals.RUBY], minerals[Inventory.Minerals.RUBY])
	%Emerald.set_icon_text(Global.minerals_icon[Inventory.Minerals.EMERALD], minerals[Inventory.Minerals.EMERALD])
	%Topaz.set_icon_text(Global.minerals_icon[Inventory.Minerals.TOPAZ], minerals[Inventory.Minerals.TOPAZ])
	%Diamond.set_icon_text(Global.minerals_icon[Inventory.Minerals.DIAMOND], minerals[Inventory.Minerals.DIAMOND])
	%Amethyst.set_icon_text(Global.minerals_icon[Inventory.Minerals.AMETHYST], minerals[Inventory.Minerals.AMETHYST])
	
