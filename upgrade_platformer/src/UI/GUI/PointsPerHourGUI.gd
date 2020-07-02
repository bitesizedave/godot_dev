extends HBoxContainer

onready var ppm_label = $PointsPerMinuteLabel

func _ready():
	ScoreTimer.connect("score_timer_updated", self, "_on_score_timer_updated")
	ScoreTimer.connect("timeout", self, "_on_score_timer_timeout")

func _process(delta):
	pass


func _on_score_timer_updated():
	if ScoreTimer.score_per_hour() == 0.0:
		ppm_label.modulate = Color(1, 1, 1, 0)
	else: 
		ppm_label.modulate = Color(1, 1, 1, 1)
		ppm_label.text = str(round(ScoreTimer.score_per_minute()), "\nper\nminute")


func _on_score_timer_timeout():
	pass
#	var pph_anim = $PointsPerHourLabel/PointsPerHourAP
#	pph_anim.stop()
#	pph_anim.play("fade_out")
