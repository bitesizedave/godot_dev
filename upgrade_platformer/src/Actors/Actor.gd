extends WrappingObject
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var max_speed: = Vector2(1600.0,1600.0)
var gravity: = 1000
var _velocity: = Vector2.ZERO


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if _velocity.y > max_speed.y:
		_velocity.y = max_speed.y 


