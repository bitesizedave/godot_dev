
extends State
"""Dash in input direction.
Delegates movement to its parent Move state and extends it
with state transitions
"""

var attack: = get_parent()
var dash_velocity: = Vector2()
var old_velocity: = Vector2()
onready var dash_timer: Timer = $DashTimer


func _ready():
	dash_timer.connect("timeout", self, "on_DashTimer_timeout")


func unhandled_input(event: InputEvent) -> void:
	attack.unhandled_input(event)


func physics_process(delta: float) -> void:
	if attack.get_move_direction().x == 0.0 and owner.is_on_floor():
		if abs(attack.velocity.x) <= 0.1:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	attack.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	get_parent().enter(msg)


func exit() -> void:
	get_parent().exit()


func on_DashTimer_timeout():
	return
