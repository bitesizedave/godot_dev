extends Node

signal battling_entered
signal not_battling_entered


var game_state: = 0 setget set_game_state
enum {BATTLING,NOT_BATTLING}


func set_game_state(value: int):
	match value:
		BATTLING:
			emit_signal("battling_entered")
		NOT_BATTLING:
			emit_signal("not_battling_entered")
	game_state = value
