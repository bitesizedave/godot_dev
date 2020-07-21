extends Node2D

onready var start_coins: = WorldData.start_coins
var coin_positions: = []
onready var coin_scene = preload("res://src/Objects/Coin/Coin.tscn")
var coins: = []

func _ready():
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	for n in get_children():
		coin_positions.push_back(n.position)
	

func _on_battling_entered():
	if coin_positions.size() >= WorldData.start_coins:
		start_coins = WorldData.start_coins
	else:
		start_coins = coin_positions.size()
	for n in start_coins:
		var coin = coin_scene.instance()
		coin.position = coin_positions[n]
		add_child(coin)
		
