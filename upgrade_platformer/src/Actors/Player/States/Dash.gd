
extends State
"""Dash in input direction.
Delegates movement to its parent Move state and extends it
with state transitions
"""

var attack: = get_parent()
var dash_velocity: = Vector2()
export var max_dash_velocity: = Vector2(2000.0, 2000.0)
export var dash_acceleration_default: = 25000.0
var dash_acceleration: = dash_acceleration_default
onready var dash_timer: Timer = $DashTimer
var velocity: = Vector2.ZERO
var facing_direction: = Vector2.ZERO


func _ready():
	dash_timer.connect("timeout", self, "on_DashTimer_timeout")


#func unhandled_input(event: InputEvent) -> void:
#	attack.unhandled_input(event)


func physics_process(delta: float) -> void:
	var attack: = get_parent()
	if attack.get_attack_direction().x == 0.0 and owner.is_on_floor() and dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Idle")
	elif attack.get_attack_direction().x > 0.0 and owner.is_on_floor() and dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Run", { "dash_direction": attack.direction })
	elif dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Air", { "dash_direction": attack.direction})
	dash_velocity = calculate_dash_velocity(dash_velocity, 
		max_dash_velocity, 
		dash_acceleration, delta, 
		facing_direction if attack.get_attack_direction() == Vector2.ZERO else attack.get_attack_direction())
	dash_velocity = owner.move_and_slide(dash_velocity, owner.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	dash_timer.start()
	dash_velocity = Vector2.ZERO
	if "facing_direction" in msg:
		facing_direction = msg["facing_direction"]



func exit() -> void:
	var attack = get_parent()
	dash_velocity = Vector2.ZERO


static func calculate_dash_velocity(
		old_velocity: Vector2,
		max_dash_velocity: Vector2,
		acceleration: float,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_dash_velocity.x, max_dash_velocity.x)
	new_velocity.y = clamp(new_velocity.y, -max_dash_velocity.y, max_dash_velocity.y)
	return new_velocity


func on_DashTimer_timeout():
	return
