extends GameState
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_battle_state"):
		_game_state_machine.transition_to("NotBattling")


func physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("BATTLE_OBJECTS").size() <= 0:
		_game_state_machine.transition_to("NotBattling")
	pass

func enter(msg: Dictionary = {}) -> void:
	BattleTimer.wait_time = BattleTimer.BATTLE_TIME
	BattleTimer.start()
	WorldData.battle_score = 0
	GameStateData.set_game_state(GameStateData.BATTLING)


func exit() -> void:
#	var _scoretime = BattleTimer.BATTLE_TIME - BattleTimer.time_left 
#	ScoreTimer.set_score_time(_scoretime)
	pass
