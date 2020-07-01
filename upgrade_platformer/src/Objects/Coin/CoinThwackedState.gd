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
var thwack_velocity: Vector2
onready var thwack_timer = $CoinThwackedTimer
onready var coin = get_parent()


func physics_process(delta: float) -> void:
	owner.move_and_slide(thwack_velocity*delta)


func enter(msg: Dictionary = {}) -> void:
	if "thwack_direction" in msg:
		thwack_direction = msg["thwack_direction"]
		print(thwack_direction)
		thwack_velocity = thwack_impulse * thwack_direction
		thwack_timer.start()
		emit_signal("thwack_entered")

func exit() -> void:
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node

