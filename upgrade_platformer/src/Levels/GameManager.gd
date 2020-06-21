extends Node2D


onready var coin_scene = preload("res://src/Objects/Coin.tscn")


func _ready():
	WorldData.connect("hard_reset", self, "on_hard_reset")

func _on_Battling_entered():
	WorldData.set_wrapping(true)
	var coin = coin_scene.instance()
	add_child(coin)
	coin.position = Vector2(100,50)
	BattleTimer.start()

func _on_NotBattling_entered():
	WorldData.set_wrapping(false)


func on_hard_reset():
	$PlayerSquare.position = PlayerData.player_game_start_position
	$GameStateMachine.transition_to("NotBattling")
	



