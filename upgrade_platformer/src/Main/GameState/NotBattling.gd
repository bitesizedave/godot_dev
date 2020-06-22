extends GameState
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""

signal not_battling_entered

#onready var main_level: Node = get_node("/root/MainScene")
#onready var background_rect: TextureRect = get_node("MainLevel/Background/BackgroundRect")

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_battle_state"):
		_game_state_machine.transition_to("Battling")


func physics_process(delta: float) -> void:
	pass


func enter(msg: Dictionary = {}) -> void:
	ScoreTimer.set_score_time(BattleTimer.BATTLE_TIME - BattleTimer.time_left)
	ScoreTimer.start()
	print("not_battling_entered")
	emit_signal("not_battling_entered")
	


func exit() -> void:
	pass

