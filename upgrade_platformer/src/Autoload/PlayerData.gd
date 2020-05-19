extends Node

signal jump_count_updated

var jump_count: = 2 setget set_jump_count, get_jump_count

func set_jump_count(value: int) -> void:
	jump_count = value
	emit_signal("jump_count_updated")

func get_jump_count() -> int:
	return jump_count	
