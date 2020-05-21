extends Node
class_name State,"res://assets/icons/state.svg"
"""
State interface to use in hierarchical State Machines
The lowest leaf tries to handle callbacks, and if it can't, it delegates the
work to it's parent.
It's up to the user to call the parent's state functions e.g.
'get_parent().physics_process(delta)'
Use State as a child of StateMachine Node
"""

onready var _state_machine: = _get_state_machine(self)

func _unhandled_input(event: InputEvent) -> void:
	return

func physics_process(delta: float) -> void:
	return

func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
