extends HBoxContainer

onready var timer_label = $BattleTimerMargin/BattleTimerLabel

func _process(delta):
	timer_label.text = (str(round(BattleTimer.get_battle_time_left())) + ":"
		+ str(stepify(BattleTimer.get_battle_time_left() - int(BattleTimer.get_battle_time_left()),.01)).right(2))
