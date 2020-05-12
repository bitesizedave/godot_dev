extends KinematicBody2D

export var speed: = 1200
export var jump_speed: = -1800
export var gravity: = 4000

var velocity: = Vector2.ZERO

func get_input():
	velocity.x = 0
	velocity.x = get_direction().x * speed
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left")
		,Input.get_action_strength("down") - Input.get_action_strength("up"))

func _physics_process(delta: float) -> void:
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
