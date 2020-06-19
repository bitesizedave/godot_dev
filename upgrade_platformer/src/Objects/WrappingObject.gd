extends KinematicBody2D
class_name WrappingObject

func _physics_process(delta):
	if WorldData.wrapping:
		self.position = wrap_position(true, true, true, true)
	elif (WorldData.is_in_top_room(self.position)):
		self.position = wrap_position(true, true, false, true)
#		print("top")
	elif (WorldData.is_in_bottom_room(self.position)):
		self.position = wrap_position(false, true, true, true)
#		print("bottom")
	elif (WorldData.is_in_right_room(self.position)):
		self.position = wrap_position(true, true, true, false)
#		print("right")
	elif (WorldData.is_in_left_room(self.position)):
		self.position = wrap_position(true, false, true, true)
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
	
