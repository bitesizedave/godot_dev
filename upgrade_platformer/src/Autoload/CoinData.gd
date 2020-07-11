extends Node

signal base_thwack_impulse_updated
signal thwack_acceleration_updated
signal thwack_score_added_updated

var base_thwack_impulse: = 120000.0 setget set_base_thwack_impulse, get_base_thwack_impulse
var thwack_acceleration: = 1.5 setget set_thwack_acceleration, get_thwack_acceleration
var thwack_score_added: = 1 setget set_thwack_score_added, get_thwack_score_added

func set_base_thwack_impulse(value) -> bool:
	base_thwack_impulse = value
	emit_signal("base_thwack_impulse_updated")
	return true


func get_base_thwack_impulse() -> float:
	return base_thwack_impulse


func set_thwack_acceleration(value: float) -> bool:
	thwack_acceleration = value
	emit_signal("thwack_acceleration_updated")
	return true


func get_thwack_acceleration() -> float:
	return thwack_acceleration


func set_thwack_score_added(value: int):
	thwack_score_added = value
	emit_signal("thwack_score_added_updated")


func get_thwack_score_added() -> int:
	return thwack_score_added
