extends GameState
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""

signal battling_entered


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_battle_state"):
		_game_state_machine.transition_to("NotBattling")


func physics_process(delta: float) -> void:
	pass


func enter(msg: Dictionary = {}) -> void:
	emit_signal("battling_entered")


func exit() -> void:
	pass
