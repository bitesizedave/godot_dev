
extends State
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""

export var max_speed_default: = Vector2(333.0, 1500.0)
export var gravity = 1500.0
var acceleration_default: = Vector2(100000, gravity)
export var max_fall_speed: = 1500.0
var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var facing_direction: = Vector2.ZERO

const WORLD_BIT_LAYER: = 3
onready var drop_timer: Timer = $DropTimer

func _ready():
	drop_timer.connect("timeout", self, "on_DropTimer_timeout")

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		_state_machine.transition_to("Attack/Dash", { "facing_direction": facing_direction })
		velocity = Vector2.ZERO
	elif event.is_action_pressed("thwack"):
		_state_machine.transition_to("Attack/Thwack")
	if owner.is_on_floor() and event.is_action_pressed("jump") and Input.get_action_strength("down") > 0.0:
		owner.set_collision_mask_bit(WORLD_BIT_LAYER, false)
		drop_timer.start()
		_state_machine.transition_to("Move/Air")
		
	elif owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = true })
	elif event.is_action_released("jump") and not owner.get_collision_mask_bit(WORLD_BIT_LAYER):
		owner.set_collision_mask_bit(WORLD_BIT_LAYER, true)


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction(), max_fall_speed)
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	_set_facing_direction()


func enter(msg: Dictionary = {}):
	if "dash_direction" in msg:
		velocity = max_speed * msg["dash_direction"]
	else: pass


func exit():
	_set_facing_direction()


static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2,
		max_fall_speed: float
	) -> Vector2:
	var new_velocity: = old_velocity
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_fall_speed)
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		1.0
	)


func _set_facing_direction():
	if get_move_direction().x != 0.0:
		facing_direction = Vector2(get_move_direction().x,0)



func on_DropTimer_timeout():
	owner.set_collision_mask_bit(WORLD_BIT_LAYER, true)
