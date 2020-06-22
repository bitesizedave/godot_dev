extends HBoxContainer

onready var score = $ScoreBox/ScoreLabel

func _ready():
	WorldData.connect("score_updated", self, "on_score_updated")
	score.text = str(WorldData.score)

func on_score_updated():
	score.text = str(WorldData.score)
