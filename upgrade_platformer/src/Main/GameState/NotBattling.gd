extends GameState
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a GameStateMachine node.
"""

onready var start_battle_scene = preload("res://src/Objects/StartBattle.tscn")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_battle_state"):
		_game_state_machine.transition_to("Battling")


func physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("BATTLE_OBJECTS").size() > 0:
		_game_state_machine.transition_to("Battling")


func enter(msg: Dictionary = {}) -> void:
	ScoreTimer.update_score_timer(WorldData.battle_score, BattleTimer.BATTLE_TIME - BattleTimer.time_left)
	GameStateData.set_game_state(GameStateData.NOT_BATTLING)
	var start_battle = start_battle_scene.instance()
	start_battle.position = Vector2(PlayerData.player_game_start_position.x+64, PlayerData.player_game_start_position.y-64)
	add_child(start_battle)


func exit() -> void:
	pass

