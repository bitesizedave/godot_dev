extends HBoxContainer

onready var timer_label = $BattleTimerMargin/BattleTimerLabel

func _process(delta):
	if BattleTimer.is_stopped():
		timer_label.visible = false
	else: 
		timer_label.visible = true
		var time: = BattleTimer.time_left
		timer_label.text = str(time).substr(0, 2) + ":" + str(time).substr(3, 2)
