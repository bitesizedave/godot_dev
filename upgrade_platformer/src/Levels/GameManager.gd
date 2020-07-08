extends Node2D

func _ready():
	WorldData.connect("hard_reset", self, "on_hard_reset")
	WorldData.connect("instant_battle_started", self, "on_instant_battle_started")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")


func _unhandled_input(event):
		if (event.is_action_pressed("start_battle")
			or event.is_action_pressed("hard_reset")):
			WorldData.set_battle_score(0)
			on_instant_battle_started()

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
		get_tree().call_group("BATTLE_OBJECTS","queue_free")
		camera.position = Vector2.ZERO
		WorldData.camera_position = Vector2.ZERO
		player.position = PlayerData.player_game_start_position



