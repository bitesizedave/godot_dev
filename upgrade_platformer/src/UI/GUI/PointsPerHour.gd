extends HBoxContainer

onready var pph_label = $PointsPerHourLabel

func _ready():
	ScoreTimer.connect("score_time_set", self, "on_score_time_set")

func _process(delta):
	pass


func on_score_time_set():
	pph_label.text = "points per hour: " + str(round(ScoreTimer.score_per_hour()))
