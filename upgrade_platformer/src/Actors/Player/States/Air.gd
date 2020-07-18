
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
var is_ledge_falling = false
var velocity 
var top_of_jump_velocity_gate: = 1.0
var top_of_jump_float_factor_default: = 0.0
var top_of_jump_float_factor: float
onready var drop_timer = get_parent().get_node("DropTimer")
var is_dropping: bool
var drop_velocity: = 10.0


onready var ledge_assist: Timer = $LedgeAssist

func _ready():
	ledge_assist.connect("timeout", self, "_on_ledge_assist_timeout")
	drop_timer.connect("timeout", self, "_on_drop_timer_timeout")

func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	if (event.is_action_pressed("jump") #jumping from the ground with ledge_assist
		and ledge_assist.time_left > 0.0):
			jump()
	elif (event.is_action_pressed("jump")
		and is_ledge_falling
		and jump_count < PlayerData.jump_count -1):
			jump()
	elif (event.is_action_pressed("jump")
		and not is_ledge_falling
		and jump_count < PlayerData.jump_count):
			jump()
	if event.is_action_released("jump") and move.velocity.y < 0:
		move.velocity.y *= .55
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	move.physics_process(delta)
	if move.get_move_direction().x == 0:
		move.velocity.x *= air_deceleration
	#Add some float if the y velocity is small
	if (move.velocity.y > -top_of_jump_velocity_gate
		and top_of_jump_float_factor < 1.0
		and not (drop_timer.time_left > 0.0 or is_dropping)):
		move.velocity.y *= top_of_jump_float_factor
		top_of_jump_float_factor += 0.0666
		print(move.velocity.y)
	#adjust velocity when dropping
	if (drop_timer.time_left > 0.0):
		move.velocity.y += drop_velocity



	# Landing
	if owner.is_on_floor():
		is_dropping = false
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.enter(msg)
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	if "impulse" in msg: # when jump button is pressed
		is_ledge_falling = false
		jump()
	else:
		ledge_assist.start()
		is_ledge_falling = true

func exit() -> void:
	var move: = get_parent()
	is_dropping = false
	jump_count = 0
	is_ledge_falling = false
	if (top_of_jump_float_factor != top_of_jump_float_factor_default):
			top_of_jump_float_factor = top_of_jump_float_factor_default
	move.exit()


func jump():
	var move: = get_parent()
	is_dropping = false
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


func _on_ledge_assist_timeout():
	is_ledge_falling = true


func _on_drop_timer_timeout():
	is_dropping = true
