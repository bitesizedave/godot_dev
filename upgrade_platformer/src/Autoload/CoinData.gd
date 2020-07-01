extends Node

signal base_thwack_impulse_changed

var base_thwack_impulse: = 150000.0 setget set_base_thwack_impulse, get_base_thwack_impulse


func set_base_thwack_impulse(value) -> bool:
	base_thwack_impulse = value
	emit_signal("base_thwack_impulse_changed")
	return true


func get_base_thwack_impulse() -> float:
	return base_thwack_impulse
