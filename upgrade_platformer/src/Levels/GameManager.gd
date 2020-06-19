extends Node2D


onready var coin_scene = preload("res://src/Objects/Coin.tscn")

func _on_Battling_entered():
	WorldData.set_wrapping(true)
	var coin = coin_scene.instance()
	add_child(coin)
	coin.position = Vector2(100,50)
	BattleTimer.start_battle_timer()

func _on_NotBattling_entered():
	WorldData.set_wrapping(false)



