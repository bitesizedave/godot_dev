extends Node
class_name Attack, "res://assets/icons/state.svg"
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""


onready var _state_machine: = _get_state_machine(self)
var facing_direction: = Vector2.ZERO
var direction: = Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		direction = get_attack_direction()
		_state_machine.transition_to("Attack/Dash")
	if event.is_action_pressed("thwack"):
		direction = get_attack_direction()
		_state_machine.transition_to("Attack/Thwack")



#func enter(msg: Dictionary = {}) -> void:
#	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node


static func get_attack_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
