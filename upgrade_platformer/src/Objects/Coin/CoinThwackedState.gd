extends State
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""

signal thwack_entered

var thwack: ThwackArea
var thwack_direction: Vector2
onready var thwack_impulse = CoinData.base_thwack_impulse
var initial_thwack_velocity: Vector2
var modified_thwack_velocity: Vector2
var thwack_friction: = 0.995
onready var thwack_timer = $CoinThwackedTimer
onready var coin = get_parent().owner
var consecutive_thwack_value: int



func physics_process(delta: float) -> void:
	modified_thwack_velocity *= thwack_friction
	owner.move_and_slide(modified_thwack_velocity 
	* delta)


func enter(msg: Dictionary = {}) -> void:
	if "thwack_direction" in msg:
		thwack_direction = msg["thwack_direction"]
		modified_thwack_velocity = thwack_direction
		thwack_timer.start()
		emit_signal("thwack_entered")
	if "consecutive_thwack_value" in msg:
		consecutive_thwack_value = msg["consecutive_thwack_value"]
		modified_thwack_velocity += thwack_impulse * thwack_direction
		modified_thwack_velocity += consecutive_thwack_value * (thwack_impulse/10) * thwack_direction
	coin.get_node("CoinAreaDetector/CoinSprite").modulate = Color.green

func exit() -> void:
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node

