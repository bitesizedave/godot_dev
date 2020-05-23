extends State

onready var move: = get_parent()
export var acceleration_x: = 5000.0

func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	move.physics_process(delta)
	
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0.0 else "Move/Run"


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed_default.x)
	if "impulse" in msg:
		move.velocity += calculate_jump_velocity(msg.impulse)


func exit() -> void:
	move.acceleration = move.acceleration_default
	move.exit()


func calculate_jump_velocity(impulse: = 0.0) -> Vector2:
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)
