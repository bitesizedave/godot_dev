extends HBoxContainer

onready var timer_label = $BattleTimerMargin/BattleTimerLabel

func _process(delta):
	var time: = BattleTimer.time_left
	timer_label.text = str(time).substr(0, 2) + ":" + str(time).substr(3, 2)
