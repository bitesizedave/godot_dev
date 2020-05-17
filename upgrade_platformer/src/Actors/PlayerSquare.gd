extends Actor
class_name PlayerSquare#, "res://assets/square.png"

export var player_speed: = Vector2(300.0,100.0)
export (float, 0.0, 1.0) var acceleration = 0.2
export (float, 0.0, 1.0) var friction = 0.8
export var drop_speed: = 100.0
export var jump_floatyness_dampener: = 3
export var jump_boost: = 5.0
export var jump_boost_counter: = 10
var jbc: = jump_boost_counter
export var jump_assist_counter: = 5
var jac: = 0
var can_jump: = false
var is_jumping: = false

func _on_body_entered(body: PhysicsBody2D) -> void:
	die()

#func _ready() -> void:
#	print("controllers connected: ",Input.get_connected_joypads())

func _physics_process(delta: float) -> void:
	if is_dropping(): drop()
	var is_jump_interrupted = set_is_jump_interrupted()
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, player_speed,is_jump_interrupted)
	set_jump_boost_counter()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	set_jump_boost_counter()
	set_jump_assist_counter()
	set_can_jump()
	set_is_jumping()
	set_is_jump_interrupted()
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("jump") && can_jump && !is_dropping() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity 
	if direction.x != 0.0:
		out.x = lerp(out.x, direction.x * speed.x, acceleration)
	else:
		out.x = lerp(out.x, 0.0, friction)
			
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0 && can_jump && !is_jumping:
		out.y = speed.y * direction.y
	if jump_boost_counter > 0 && out.y < 0.0: 
		out.y -= jump_boost * jbc
	if is_jump_interrupted:
		out.y = out.y/jump_floatyness_dampener
	return out


func is_dropping() -> bool: 
	return (Input.get_action_strength("down") && Input.is_action_just_pressed("jump") && is_on_floor())

func drop() -> void:
	position.y += 2
	_velocity.y += drop_speed

func set_jump_boost_counter() -> void:
	if can_jump: jbc = jump_boost_counter
	elif jbc > 0 && Input.get_action_strength("jump") > 0.0: 
		jbc -= 1

func set_jump_assist_counter() -> void:
	if is_on_floor(): 
		jac = jump_assist_counter
	elif jump_assist_counter > 0:
		jac -= 1
	else:
		jac = 0

func set_can_jump() -> void:
	if jac > 0:
		can_jump = true
	else: 
		can_jump = false

func set_is_jumping() -> void:
	if _velocity.y < 0.0 && Input.get_action_strength("jump") > 0 : is_jumping = true
	else: is_jumping = false

func set_is_jump_interrupted() -> bool:
	return Input.is_action_just_released("jump") && !is_jumping && jac <= 0 && jbc <= 0

func die() -> void:
	WorldData.deaths += 1
	queue_free()
