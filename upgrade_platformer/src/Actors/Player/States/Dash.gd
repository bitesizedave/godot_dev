
extends State
"""Dash in input direction.
Delegates movement to its parent Move state and extends it
with state transitions
"""

signal dash_started
signal dash_ended

onready var attack: = get_parent()
var dash_velocity: = Vector2()
export var max_dash_velocity: = Vector2(2500.0, 2500.0)
export var dash_acceleration_default: = 35000.0
var dash_acceleration: = dash_acceleration_default
onready var dash_timer: Timer = $DashTimer
var velocity: = Vector2.ZERO
var facing_direction: = Vector2.ZERO
onready var top_dash_ray: = $TopDashRay
onready var bottom_dash_ray: = $BottomDashRay


func _ready():
	dash_timer.connect("timeout", self, "on_DashTimer_timeout")
	


func physics_process(delta: float) -> void:
	var last_position = attack.owner.get_node("CollisionShape2D").get_global_position()
	var attack: = get_parent()
	var attack_direction = attack.get_attack_direction()
	if attack_direction.x == 0.0 and owner.is_on_floor() and dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Idle")
	elif attack_direction.x > 0.0 and owner.is_on_floor() and dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Run", { "dash_direction": attack_direction })
	elif dash_timer.get_time_left() ==  0.0:
		_state_machine.transition_to("Move/Air", { "dash_direction": attack_direction})
	dash_velocity = calculate_dash_velocity(dash_velocity, 
		max_dash_velocity, 
		dash_acceleration, delta, 
		facing_direction if attack_direction == Vector2.ZERO else attack_direction)
	dash_velocity = owner.move_and_slide(dash_velocity, owner.FLOOR_NORMAL)
	top_dash_ray.position = attack.owner.position - Vector2(0, attack.owner.get_node("CollisionShape2D").shape.extents.y/1.5)
	top_dash_ray.cast_to = last_position - owner.position
	top_dash_ray.force_raycast_update()
	if top_dash_ray.is_colliding():
		var object = top_dash_ray.get_collider()
	bottom_dash_ray.position = attack.owner.position + Vector2(0, attack.owner.get_node("CollisionShape2D").shape.extents.y/1.5)
	bottom_dash_ray.cast_to = last_position - owner.position
	bottom_dash_ray.force_raycast_update()

func enter(msg: Dictionary = {}) -> void:
	var last_position = attack.owner.get_node("CollisionShape2D").get_global_position()
	dash_timer.start()
	emit_signal("dash_started")
	dash_velocity = Vector2.ZERO
	if "facing_direction" in msg:
		facing_direction = msg["facing_direction"]
	top_dash_ray.enabled = true
	bottom_dash_ray.enabled = true

func exit() -> void:
	emit_signal("dash_ended")
	top_dash_ray.enabled = false
	bottom_dash_ray.enabled = false


static func calculate_dash_velocity(
		old_velocity: Vector2,
		max_dash_velocity: Vector2,
		acceleration: float,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity
#	new_velocity += move_direction.normalized() * acceleration * delta
	new_velocity = move_direction.normalized() * max_dash_velocity
	new_velocity.x = clamp(new_velocity.x, -max_dash_velocity.x, max_dash_velocity.x)
	new_velocity.y = clamp(new_velocity.y, -max_dash_velocity.y, max_dash_velocity.y)
	return new_velocity


func on_DashTimer_timeout():
	return


func _set_dash_ray():
	pass
