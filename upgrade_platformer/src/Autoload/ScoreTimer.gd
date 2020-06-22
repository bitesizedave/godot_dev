extends Timer

signal score_time_set 


var score_time: = 0.0 setget set_score_time


func _ready():
	one_shot = false
	connect("timeout", self, "on_timeout")


func set_score_time(value: float):
	score_time = value
	wait_time = score_time
	emit_signal("score_time_set")


func on_timeout():
	WorldData.score += WorldData.battle_score


func score_per_minute() -> float:
	if score_time > 0.0:
		return WorldData.battle_score * (60/score_time)
	else: return 0.0


func score_per_hour() -> float:
	if score_time > 0.0:
		return score_per_minute() * 60
	else: return 0.0


func score_per_day() -> float:
	if score_time > 0.0:
		return score_per_hour() *24
	else: return 0.0
