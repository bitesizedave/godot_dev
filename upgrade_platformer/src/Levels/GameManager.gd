extends Node2D

onready var start_battle_scene = preload("res://src/Objects/StartBattle.tscn")

func _ready():
	WorldData.connect("hard_reset", self, "on_hard_reset")
	WorldData.connect("instant_battle_started", self, "on_instant_battle_started")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")

func _on_battling_entered():
	WorldData.set_wrapping(true)


func _on_not_battling_entered():
	get_tree().call_group("BATTLE_OBJECTS","queue_free")
	BattleTimer.stop()
	WorldData.set_wrapping(false)


func on_hard_reset():
	$PlayerSquare.position = PlayerData.player_game_start_position
	get_tree().call_group("BATTLE_OBJECTS","queue_free")
	$GameStateMachine.transition_to("NotBattling")



func on_instant_battle_started():
		var camera = $Camera
		var player = $PlayerSquare
		var game_state_machine = $GameStateMachine
		WorldData.set_wrapping(false)
		camera.smoothing_enabled = false
		camera.position = Vector2.ZERO
		WorldData.camera_position = Vector2.ZERO
		player.position = PlayerData.player_game_start_position
		var start_battle = start_battle_scene.instance()
		start_battle.position = Vector2(PlayerData.player_game_start_position.x+32, PlayerData.player_game_start_position.y)
		add_child(start_battle)
#		game_state_machine.transition_to("Battling")
		yield(get_tree().create_timer(0.1), "timeout")
		WorldData.set_wrapping(true)
		camera.smoothing_enabled = true


