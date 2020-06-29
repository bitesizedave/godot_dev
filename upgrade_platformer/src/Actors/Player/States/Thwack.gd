extends State
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""

onready var thwack_area_scene = preload("res://src/Actors/Player/ThwackArea.tscn")
var thwack
var thwack_velocity: = Vector2.ZERO
onready var attack: = get_parent()
var attack_direction: Vector2
var thwack_offset: = 18.0

func unhandled_input(event: InputEvent) -> void:
	pass


func physics_process(delta: float) -> void:
	owner.move_and_slide(thwack_velocity, owner.FLOOR_NORMAL)
	


func enter(msg: Dictionary = {}) -> void:
	thwack = thwack_area_scene.instance()
	add_child(thwack)
	thwack.connect("done_thwackin", self, "_on_done_thwackin")
	var attack_direction = attack.get_attack_direction().normalized()
	thwack.position = owner.position 
	thwack.look_at(owner.position + attack_direction)
	var thwack_direction = Vector2(cos(thwack.rotation), sin(thwack.rotation))
	thwack.position += thwack_direction * thwack_offset
	
	
	
	


func exit() -> void:
	pass


func _on_done_thwackin():
	_state_machine.transition_to("Move/Idle")


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
