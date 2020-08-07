extends Node2D

export var speed := 300.0

var _direction := Vector2.RIGHT

func _process(delta: float) -> void:
	_direction = global_position.direction_to(get_global_mouse_position())
	rotation = _direction.angle()
	translate((_direction * speed) * delta)
