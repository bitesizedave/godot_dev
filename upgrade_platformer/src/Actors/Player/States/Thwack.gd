extends State

onready var thwack_area_scene = preload("res://src/Actors/Player/ThwackArea.tscn")
var thwack: Area2D
var thwack_raycast: RayCast2D
var thwack_velocity: = Vector2.ZERO
var thwack_max_speed: = Vector2(333.0, 666.0)
onready var gravity = WorldData.gravity
var thwack_impulse_default: = 30000.0
var thwack_impulse: float
var thwacked_something_impulse: = false
var attack_direction: Vector2 
var thwack_offset: = 18.0
var facing_direction: = Vector2.ZERO
onready var attack: = get_parent()
onready var after_thwack_delay_timer = $AfterThwackDelayTimer


func _ready():
	thwack_impulse = thwack_impulse_default

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("thwack"):
		after_thwack_delay_timer.stop()
		_state_machine.transition_to("Move/Thwack", { "facing_direction": facing_direction })


func physics_process(delta: float) -> void:
	thwack.position = owner.position 
	var thwack_direction = Vector2(cos(thwack.rotation), sin(thwack.rotation))
	thwack.position += thwack_direction * thwack_offset
	if (thwacked_something_impulse
		and get_thwack_direction().y == 1
		and get_thwack_direction().x <= 1
		and get_thwack_direction().x >= -1):
		if thwack_impulse > gravity:
			thwack_impulse -= gravity
		thwack_velocity = calculate_thwack_velocity(thwack_velocity,
			thwack_max_speed, thwack_impulse, delta, -thwack_direction)
	owner.move_and_slide(thwack_velocity, owner.FLOOR_NORMAL)
	


func enter(msg: Dictionary = {}) -> void:
	thwack = thwack_area_scene.instance()
	add_child(thwack)
	thwack.connect("done_thwackin", self, "_on_done_thwackin")
	thwack_raycast = thwack.get_node("ThwackRayCast")
	if "facing_direction" in msg:
		facing_direction = msg["facing_direction"]
	var attack_direction = attack.get_attack_direction()
	if attack_direction == Vector2.ZERO:
		attack_direction = facing_direction
	attack_direction.normalized()
	thwack.position = owner.position 
	thwack.look_at(owner.position + attack_direction)
	var thwack_direction = Vector2(cos(thwack.rotation), sin(thwack.rotation))
	thwack.position += thwack_direction * thwack_offset


func exit() -> void:
	thwack_velocity = Vector2.ZERO
	thwack_impulse = thwack_impulse_default
	thwacked_something_impulse = false


func _on_done_thwackin():
	after_thwack_delay_timer.start()
	yield(after_thwack_delay_timer, "timeout")
	_state_machine.transition_to("Move/Idle")


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node


func get_thwack_direction() -> Vector2:
	var input = attack.get_attack_direction()
	if input == Vector2.ZERO:
		return facing_direction
	else: return input


func calculate_thwack_velocity(
	old_velocity: Vector2,
	max_speed: Vector2,
	acceleration: float,
	delta: float,
	move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity
	new_velocity += move_direction * acceleration * delta
	new_velocity.y += gravity * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	return new_velocity


