extends Node

signal score_updated
signal player_died

var score: = 0 setget set_score, get_score
var deaths: = 0 setget set_deaths, get_deaths

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
	

