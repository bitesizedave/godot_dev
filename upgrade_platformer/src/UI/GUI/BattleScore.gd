extends HBoxContainer

onready var score = $ScoreBox/ScoreLabel

func _ready():
	WorldData.connect("battle_score_updated", self, "on_battle_score_updated")
	score.text = str(WorldData.battle_score)

func on_battle_score_updated():
	score.text = str(WorldData.battle_score)