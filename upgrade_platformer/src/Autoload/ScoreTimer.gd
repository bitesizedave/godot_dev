extends Timer

signal score_time_set 

#onready var score_timer: Timer = $Timer
var score_time: = 0.0 setget set_score_time


func _ready():
	one_shot = false


func set_score_time(value: float):
	score_time = value
	emit_signal("score_time_set")
