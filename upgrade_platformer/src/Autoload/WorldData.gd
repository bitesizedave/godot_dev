extends Node

signal score_updated
signal wrapping_toggled
signal camera_position_updated
signal battle_score_updated
signal coin_value_updated
signal hard_reset
signal instant_battle_started
signal start_coins_updated

var score: = 0 setget set_score, get_score
onready var battle_score: = 0 setget set_battle_score, get_battle_score
onready var coin_value: = 1 setget set_coin_value, get_coin_value
onready var start_coins: = 9 setget set_start_coins, get_start_coins
var wrapping: = false setget set_wrapping, get_wrapping
var camera_position: = Vector2() setget set_camera_position, get_camera_position 
var screen_left_edge: = 0.0 setget ,get_screen_left_edge
var screen_right_edge: = 0.0 setget ,get_screen_right_edge
var screen_top_edge: = 0.0 setget ,get_screen_top_edge
var screen_bottom_edge: = 0.0 setget ,get_screen_bottom_edge

onready var battle_room_dimensions: = {
	"br_left": -ProjectSettings.get("display/window/size/width")/2,
	"br_right": ProjectSettings.get("display/window/size/width")/2,
	"br_top": -ProjectSettings.get("display/window/size/height")/2,
	"br_bottom": ProjectSettings.get("display/window/size/height")/2 
}

onready var project_window_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))


func _unhandled_input(event):
	if event.is_action_pressed("hard_reset"):
		hard_reset()



func hard_reset() -> void:
	set_score(0)
	set_battle_score(0)
	emit_signal("hard_reset")


func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")


func get_score() -> int:
	return score



func set_wrapping(value: bool) -> void:
	wrapping = value
	emit_signal("wrapping_toggled")


func toggle_wrapping() -> void:
	set_wrapping(!wrapping)


func get_wrapping() -> bool:
	return wrapping


func set_camera_position(value: Vector2) -> void:
	camera_position = value
	emit_signal("camera_position_updated")


func is_in_battle_room(position: Vector2) -> bool:
	return (position.x < battle_room_dimensions.br_right
		and position.x > battle_room_dimensions.br_left
		and position.y < battle_room_dimensions.br_bottom
		and position.y > battle_room_dimensions.br_top)


func is_in_top_room(position: Vector2) -> bool:
	return (position.x > battle_room_dimensions.br_left
		and position.x < battle_room_dimensions.br_right
		and position.y < battle_room_dimensions.br_top)


func is_in_bottom_room(position: Vector2) -> bool:
	return (position.x > battle_room_dimensions.br_left
		and position.x < battle_room_dimensions.br_right
		and position.y > battle_room_dimensions.br_bottom)


func is_in_left_room(position: Vector2) -> bool:
	return (position.x < battle_room_dimensions.br_left
		and position.y > battle_room_dimensions.br_top
		and position.y < battle_room_dimensions.br_bottom)


func is_in_right_room(position: Vector2) -> bool:
	return (position.x > battle_room_dimensions.br_right
		and position.y > battle_room_dimensions.br_top
		and position.y < battle_room_dimensions.br_bottom)

func get_camera_position() -> Vector2:
	return camera_position


func get_screen_left_edge() -> float:
	return (camera_position.x - project_window_size.x/2)


func get_screen_right_edge() -> float:
	return (camera_position.x + project_window_size.x/2)


func get_screen_top_edge() -> float:
	return (camera_position.y - project_window_size.y/2)


func get_screen_bottom_edge() -> float:
	return (camera_position.y + project_window_size.y/2)


func set_battle_score(value: int):
	battle_score = value
	emit_signal("battle_score_updated")


func get_battle_score() -> int:
	return battle_score


func set_coin_value(value: int):
	coin_value = value
	emit_signal("coin_value_updated")


func get_coin_value() -> int:
	return coin_value


func set_start_coins(value: int):
	start_coins = value
	emit_signal("start_coins_updated")


func get_start_coins() -> int:
	return start_coins
