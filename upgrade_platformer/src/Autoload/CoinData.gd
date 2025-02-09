extends Node

signal base_thwack_impulse_updated
signal thwack_acceleration_updated
signal thwack_score_added_updated
signal coin_tween_speed_updated
signal start_coins_updated
signal coin_value_updated
signal coin_collecting_coin_multiplier_updated


var base_thwack_impulse: = 120000.0 setget set_base_thwack_impulse, get_base_thwack_impulse
var thwack_acceleration: = 1.5 setget set_thwack_acceleration, get_thwack_acceleration
var thwack_score_added: = 1 setget set_thwack_score_added, get_thwack_score_added
var default_thwack_score_added: = 1
var coin_tween_speed: = 0.3 setget set_coin_tween_speed, get_coin_tween_speed
onready var start_coins: = 1 setget set_start_coins, get_start_coins
var save_dictionary: Dictionary
var coin_value: int = 1
var default_coin_value: = 1
var coin_collecting_coin_multiplier: int = 2 setget set_coin_collecting_coin_multiplier, get_coin_collecting_coin_multiplier
var default_coin_collecting_coin_multiplier: = 2
const COIN_LAYER = 2


func _ready():
	ScoreTimer.connect("timeout", self, "_on_score_timer_timeout")
	WorldData.connect("hard_reset", self, "_on_hard_reset")


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
	save_persist_state()
	emit_signal("thwack_score_added_updated")


func get_thwack_score_added() -> int:
	return thwack_score_added


func set_coin_tween_speed(value: float):
	coin_tween_speed = value
	emit_signal("coin_tween_speed_updated")


func get_coin_tween_speed() -> float:
	return coin_tween_speed


func set_start_coins(value: int):
	start_coins = value
	save_persist_state()
	emit_signal("start_coins_updated")


func get_start_coins() -> int:
	return start_coins


func set_coin_value(value: int):
	coin_value = value
	emit_signal("coin_value_updated")


func get_coin_value() -> int:
	return coin_value


func set_coin_collecting_coin_multiplier(value :int):
	coin_collecting_coin_multiplier = value
	emit_signal("coin_collecting_coin_multiplier_updated")


func get_coin_collecting_coin_multiplier() -> int:
	return  coin_collecting_coin_multiplier



func save_persist_state():
	save_dictionary = {
			"object_name" : self.name,
			"object_path" : self.get_path(),
			"start_coins" : start_coins,
			"coin_value" : coin_value,
			"thwack_score_added" : thwack_score_added
		}

func load_persist_state(load_dictionary: Dictionary):
	if (load_dictionary.object_name == self.name
		and load_dictionary.object_path == self.get_path()):
		start_coins = load_dictionary.start_coins
		thwack_score_added = load_dictionary.thwack_score_added


func get_save_dictionary() -> Dictionary:
	return save_dictionary


func _on_score_timer_timout():
	save_persist_state()


func _on_hard_reset():
	_reset_default_coin_values()


func _reset_default_coin_values():
	thwack_score_added = default_thwack_score_added
	coin_value = default_coin_value
	coin_collecting_coin_multiplier = default_coin_collecting_coin_multiplier
