extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var max_speed: = Vector2(1600.0,1600.0)
var gravity: = 1000
var _velocity: = Vector2.ZERO


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if _velocity.y > max_speed.y:
		_velocity.y = max_speed.y 
	if Input.is_action_just_pressed("debug_wrapping"): WorldData.toggle_wrapping()
	if WorldData.wrapping:
		self.position = wrap_position(true, true, true, true)
	elif not WorldData.wrapping and self.position.y < WorldData.battle_room_dimensions.br_top:
		self.position = wrap_position(true, true, false, true)
#		print("top")
	elif not WorldData.wrapping and self.position.x > WorldData.battle_room_dimensions.br_right:
		self.position = wrap_position(true, true, true, false)
#		print("right")
	elif not WorldData.wrapping and self.position.y > WorldData.battle_room_dimensions.br_bottom:
		self.position = wrap_position(false, true, true, true)
#		print("bottom")
	elif not WorldData.wrapping and self.position.x < WorldData.battle_room_dimensions.br_left:
		self.position = wrap_position(true, false, true, true)
#		print("left")

func wrap_position(top_wrap: bool, right_wrap: bool, bottom_wrap: bool, left_wrap: bool) -> Vector2:
	var new_position: = Vector2(self.position)
	if right_wrap:
		if position.x > WorldData.get_screen_right_edge():
			new_position.x = WorldData.get_screen_left_edge()
	if left_wrap:
		if position.x < WorldData.get_screen_left_edge():
			new_position.x = WorldData.get_screen_right_edge()
	if bottom_wrap:
		if position.y > WorldData.get_screen_bottom_edge():
			new_position.y = WorldData.get_screen_top_edge()
	if top_wrap:
		if position.y < WorldData.get_screen_top_edge():
			new_position.y = WorldData.get_screen_bottom_edge()
#	new_position.x = wrapf(position.x, 
#		WorldData.get_screen_left_edge() if left_wrap else null, 
#		WorldData.get_screen_right_edge() if right_wrap else self.position.x)
#	new_position.y = wrapf(position.y, 
#		WorldData.get_screen_top_edge() if top_wrap else self.position.y, 
#		WorldData.get_screen_bottom_edge() if bottom_wrap else self.position.y)
	return new_position

