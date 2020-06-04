extends Node

signal score_updated
signal player_died
signal wrapping_toggled
signal camera_position_updated
signal coins_updated

var score: = 0 setget set_score, get_score
var coins: = 0 setget set_coins, get_coins

var deaths: = 0 setget set_deaths, get_deaths
var wrapping: = false setget set_wrapping, get_wrapping
var camera_position: = Vector2() setget set_camera_position, get_camera_position 
var screen_left_edge: = 0.0 setget ,get_screen_left_edge
var screen_right_edge: = 0.0 setget ,get_screen_right_edge
var screen_top_edge: = 0.0 setget ,get_screen_top_edge
var screen_bottom_edge: = 0.0 setget ,get_screen_bottom_edge
#const CAMERA_POSITIONS: = {
#	"MAIN_SCREEN": Vector2(0.0, 0.0),
#	"LEFT_SCREEN": Vector2(-768.0, 0.0),
#	"RIGHT_SCREEN": Vector2(768.0, 0.0),
#	"BOTTOM_SCREEN": Vector2(0.0, 432.0),
#	"TOP_SCREEN": Vector2(0.0, -432.0)
#}

onready var battle_room_dimensions: = {
	"br_left": -ProjectSettings.get("display/window/size/width")/2,
	"br_right": ProjectSettings.get("display/window/size/width")/2,
	"br_top": -ProjectSettings.get("display/window/size/height")/2,
	"br_bottom": ProjectSettings.get("display/window/size/height")/2 
}

onready var project_window_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))

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


func set_camera_position(value: Vector2) -> void:
	camera_position = value
	emit_signal("camera_position_updated")


func get_camera_position() -> Vector2:
	return camera_position


func get_screen_left_edge() -> float:
	return (camera_position.x - project_window_size.x/2 -1)


func get_screen_right_edge() -> float:
	return (camera_position.x + project_window_size.x/2 +1)


func get_screen_top_edge() -> float:
	return (camera_position.y - project_window_size.y/2 - 1)


func get_screen_bottom_edge() -> float:
	return (camera_position.y + project_window_size.y/2 + 1)


func set_coins(value: int):
	coins = value
	emit_signal("coins_updated")


func get_coins() -> int:
	return coins
