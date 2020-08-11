extends Node2D

onready var start_coins: = CoinData.start_coins
var coin_positions: = []
onready var coin_scene = preload("res://src/Objects/Coin/Coin.tscn")
#var coins: = []

func _ready():
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	GameStateData.connect("not_battling_entered", self, "_on_battling_exited")
	for n in get_children():
		coin_positions.push_back(n.position)


func _on_battling_entered():
	if get_tree().get_nodes_in_group("COINS").size() == 0:
		_on_battling_exited()
	_toggle_coin_collision_layers(true)


func _on_battling_exited():
#	#remove the old coin references
#	for coin in get_tree().get_nodes_in_group("COINS"):
#		coin.queue_free()
	#create new coins
	if coin_positions.size() >= CoinData.start_coins:
		start_coins = CoinData.start_coins
	else:
		start_coins = coin_positions.size()
	for n in start_coins:
		var coin = coin_scene.instance()
		coin.position = coin_positions[n]
		add_child(coin)
	_toggle_coin_collision_layers(false)


func _toggle_coin_collision_layers(value: bool):
	var all_the_coins = get_tree().get_nodes_in_group("COINS")
	if all_the_coins.size() > 0:
#		print(str(all_the_coins))
		for coin in all_the_coins:
			var coin_area = owner.get_node(str(coin.get_path(),"/CoinAreaDetector"))
			coin.visible = value
			print(str(coin_area))
			coin_area.set_collision_mask_bit(CoinData.COIN_LAYER, value)
			coin_area.set_collision_mask_bit(PlayerData.PLAYER_LAYER, value)
			coin_area.set_collision_mask_bit(PlayerData.PLAYER_ATTACK_LAYER, value)
			if value:
				coin.add_to_group("BATTLE_OBJECTS")
			else: coin.remove_from_group("BATTLE_OBJECTS")
