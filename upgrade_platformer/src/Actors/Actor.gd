extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var max_speed: = Vector2(1600.0,1600.0)
var gravity: = 1000
var _velocity: = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if _velocity.y > max_speed.y:
		_velocity.y = max_speed.y 
	if Input.is_action_just_pressed("debug_wrapping"): WorldData.toggle_wrapping()
	self.position = wrap_position(self.position)
#	print("self.position = ",self.position)

func wrap_position(position: Vector2) -> Vector2:
	if WorldData.wrapping: 
		position.x = wrapf(position.x, WorldData.get_screen_left_edge(), WorldData.get_screen_right_edge())
		position.y = wrapf(position.y, WorldData.get_screen_top_edge(), WorldData.get_screen_bottom_edge())
		return position
	else: return self.position
	
