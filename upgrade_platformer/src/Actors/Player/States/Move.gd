
extends State
"""
Parent state that abstracts and handles basic movement
Move-related children states can delegate movement to it, or use its utility functions
"""

export var max_speed_default: = Vector2(333.0, 1500.0)
export var gravity = 1500.0
var acceleration_default: = Vector2(100000, gravity)
export var max_fall_speed: = 1500.0

const WORLD_BIT_LAYER: = 3

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump") and Input.get_action_strength("down") > 0.0:
		owner.set_collision_mask_bit(WORLD_BIT_LAYER, false)
		_state_machine.transition_to("Move/Air")
	elif owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { impulse = true })
	elif event.is_action_released("jump") and not owner.get_collision_mask_bit(WORLD_BIT_LAYER):
		owner.set_collision_mask_bit(WORLD_BIT_LAYER, true)


func on_World_body_exited(body: Area2D):
	owner.set_collision_mask_bit(WORLD_BIT_LAYER, true)


func enter(msg: Dictionary = {}) -> void:
	owner.connect("body_exited", self, "on_World_body_exited")


func exit() -> void:
	owner.disconnect("body_exited", self, "_on_World_body_exited")


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction(), max_fall_speed)
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)


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
