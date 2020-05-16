extends Actor
class_name PlayerSquare#, "res://assets/square.png"

export var stomp_impulse: = 1000.0
export var player_speed: = Vector2(300.0,360.0)
export (float, 0.0, 1.0) var acceleration = 0.25
export (float, 0.0, 1.0) var friction = 0.9
export var drop_speed: = 100.0
export var jump_boost: = 10.0
export var jump_boost_counter: = 10
var jbc: = jump_boost_counter

func _on_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_body_entered(body: PhysicsBody2D) -> void:
	die()

func _ready() -> void:
	print("controllers connected: ",Input.get_connected_joypads())

func _physics_process(delta: float) -> void:
	if is_dropping(): drop()
	var is_jump_interrupted: = Input.is_action_just_released("jump") && _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, player_speed,is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("jump") && is_on_floor() && !is_dropping() else 1.0
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
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	if jump_boost_counter > 0 && out.y < 0.0: 
		out.y -= jump_boost * jbc
	set_jump_boost_counter()
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
		var out: = linear_velocity
		out.y = -impulse
		return out

func is_dropping() -> bool: 
	return (Input.get_action_strength("down") && Input.is_action_just_pressed("jump") && is_on_floor())

func drop() -> void:
	position.y += 2
	_velocity.y += drop_speed

func set_jump_boost_counter() -> void:
	if is_on_floor(): jbc = jump_boost_counter
	elif jbc > 0 && Input.get_action_strength("jump") > 0.0: 
		jbc -= 1
		print("jbc = ",jbc)

func die() -> void:
	WorldData.deaths += 1
	queue_free()
