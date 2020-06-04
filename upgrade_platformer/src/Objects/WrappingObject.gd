extends KinematicBody2D
class_name WrappingObject

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_wrapping"): WorldData.toggle_wrapping()
	if WorldData.wrapping:
		self.position = wrap_position(true, true, true, true)
	elif self.position.y < WorldData.battle_room_dimensions.br_top:
		self.position.y = wrap_position(true, true, false, true).y
#		print("top")
	elif self.position.y > WorldData.battle_room_dimensions.br_bottom:
		self.position.y = wrap_position(false, true, true, true).y
#		print("bottom")
	elif self.position.x > WorldData.battle_room_dimensions.br_right:
		self.position.x = wrap_position(true, true, true, false).x
#		print("right")
	elif self.position.x < WorldData.battle_room_dimensions.br_left:
		self.position.x = wrap_position(true, false, true, true).x
#		print("left")
	else: self.position = wrap_position(true, true, true, true)
#	print(position)

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
	return new_position
	
