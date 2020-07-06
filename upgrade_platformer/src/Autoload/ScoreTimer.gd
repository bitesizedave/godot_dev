extends Timer

signal score_time_set
signal score_timer_updated


var score_time: = 0.0 setget set_score_time, get_score_time
var latest_battle_score:int setget set_latest_battle_score, get_latest_battle_score


func _ready():
	one_shot = false
	connect("timeout", self, "on_timeout")


func set_score_time(value: float):
	score_time = value
	wait_time = score_time
	emit_signal("score_time_set")


func get_score_time() -> float:
	return score_time


func on_timeout():
	WorldData.score += latest_battle_score


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


func update_score_timer(latest_score: int, time_taken: float) -> bool:
	if score_time == 0.0 and time_taken > 0.0:
		latest_battle_score = latest_score
		score_time = time_taken
		start()
		emit_signal("score_timer_updated")
		return true
	elif (time_taken <= 0.0):
		return false
	elif (score_time > 0.0
		and (latest_score / time_taken) > (latest_battle_score / score_time)):
		latest_battle_score = latest_score
		set_score_time(time_taken)
		start()
		emit_signal("score_timer_updated")
		return true
	else: return false


func set_latest_battle_score(value: int):
	latest_battle_score = value


func get_latest_battle_score() -> int:
	return latest_battle_score
