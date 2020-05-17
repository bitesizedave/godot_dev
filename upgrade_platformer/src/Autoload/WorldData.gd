extends Node

signal score_updated
signal player_died
signal wrapping_toggled

var score: = 0 setget set_score, get_score
var deaths: = 0 setget set_deaths, get_deaths
var wrapping: = false setget set_wrapping, get_wrapping

func reset() -> void:
	score = 0
	deaths = 0

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")
	
func get_score() -> int:
	return score

func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("player_died")

func get_deaths() -> int:
	return deaths

func set_wrapping(value: bool) -> void:
	wrapping = value
	emit_signal("wrapping_toggled")
	print("Wrapping toggled: ",wrapping)
	
func toggle_wrapping() -> void:
	set_wrapping(!wrapping)

func get_wrapping() -> bool:
	return wrapping
