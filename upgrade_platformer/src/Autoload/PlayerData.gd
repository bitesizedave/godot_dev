extends Node

signal player_jump_count_updated
signal player_jump_power_updated

var jump_count: = 3 setget set_jump_count, get_jump_count
var jump_power: = 444.0 setget set_jump_power, get_jump_power

func set_jump_count(value: int) -> void:
	jump_count = value
	emit_signal("player_jump_count_updated")


func get_jump_count() -> int:
	return jump_count


func set_jump_power(value: float):
	jump_power = value
	emit_signal("player_jump_power_updated")


func get_jump_power() -> float:
	return jump_power
