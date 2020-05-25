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
<<<<<<< HEAD
var ledge_assist_counter: = 60
var ledge_assist: = 0
var is_ledge_falling: = false
var drop_veloctiy: = 50.0
=======

>>>>>>> parent of 4744685... Got ledge assist up and running (off ledges)


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	if event.is_action_pressed("jump") and jump_count < PlayerData.jump_count:
		jump()
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	if move.get_move_direction().x == 0:
		move.velocity.x *= air_deceleration
#	move.velocity *= move.get_move_direction()
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
	if "impulse" in msg: # when jump button is pressed
		jump()
<<<<<<< HEAD
		is_ledge_falling = false
	if "drop" in msg:
		move.velocity.y += drop_veloctiy
		is_ledge_falling = false
	if "ledge_fall" in msg:
		is_ledge_falling = true
#	
=======
	else: # for falling off of ledges
		jump_count += 1
>>>>>>> parent of 4744685... Got ledge assist up and running (off ledges)


func exit() -> void:
	var move: = get_parent()
#	move.acceleration = move.acceleration_default
	jump_count = 0
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
