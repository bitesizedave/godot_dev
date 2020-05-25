
extends State
"""
Manages Air movement, including jumping and landing.
You can pass a msg to this state, every key is optional:
{
	velocity: Vector2, to preserve inertia from the previous state
	impulse: float, to make the character jump
}
"""


#export var acceleration_x: = 5000.0
var jump_power: = PlayerData.jump_power
var air_deceleration: = 0.6
var jump_count: = 0
var ledge_assist_counter: = 10
var ledge_assist: = 0
var can_ledge_assist_jump: = false


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	if (event.is_action_pressed("jump") 
		and jump_count < PlayerData.jump_count 
		and can_ledge_assist_jump):
		jump()
		ledge_assist = 0
		can_ledge_assist_jump = false
	elif (event.is_action_pressed("jump") 
		and jump_count < PlayerData.jump_count):
		jump()
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	if move.get_move_direction().x == 0:
		move.velocity.x *= air_deceleration
	if can_ledge_assist_jump: 
		ledge_assist += 1
	if ledge_assist > ledge_assist_counter:
		can_ledge_assist_jump = false
	move.physics_process(delta)

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.enter(msg)
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
		can_ledge_assist_jump = false
	if "impulse" in msg: # when jump button is pressed
		jump()
		can_ledge_assist_jump = false
	else:
		can_ledge_assist_jump = true
#	


func exit() -> void:
	var move: = get_parent()
#	move.acceleration = move.acceleration_default
	jump_count = 0
	ledge_assist = 0
	can_ledge_assist_jump = false
	move.exit()


func jump():
	var move: = get_parent()
	move.velocity.y = 0.0
	move.velocity += calculate_jump_velocity(jump_power)
	jump_count += 1


"""
Returns a new velocity with a vertical impulse applied to it
"""
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move: State = get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP,
		move.max_fall_speed
	)
