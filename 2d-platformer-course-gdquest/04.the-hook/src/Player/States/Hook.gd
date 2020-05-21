extends State
"""
Moves the character to the target position using the arrive_to steering behavior
Preserves the character's inertia past the hooking point
"""


const HOOK_MAX_SPEED: = 1600.0

export var arrive_push: = 500.0

var target_global_position: = Vector2(INF, INF)
var velocity: = Vector2.ZERO


func physics_process(delta: float) -> void:
	var new_velocity: = Steering.arrive_to(
		velocity,
		owner.global_position,
		target_global_position,
		HOOK_MAX_SPEED
	)
	new_velocity = new_velocity if new_velocity.length() > arrive_push else new_velocity.normalized() * arrive_push
	velocity = owner.move_and_slide(new_velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)

	var to_target: Vector2 = target_global_position - owner.global_position
	var distance: = to_target.length()

	if distance < velocity.length() * delta:
		velocity = velocity.normalized() * arrive_push
		_state_machine.transition_to("Move/Air", {velocity = velocity})


func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v


func exit() -> void:
	target_global_position = Vector2(INF, INF)
	velocity = Vector2.ZERO
