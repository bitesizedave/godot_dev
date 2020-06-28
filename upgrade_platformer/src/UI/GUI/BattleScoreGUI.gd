extends HBoxContainer

onready var score = $ScoreBox/ScoreLabel
onready var score_animation_player = $ScoreBox/ScoreLabel/ScoreLabelAnimationPlayer


func _ready():
	WorldData.connect("battle_score_updated", self, "_on_battle_score_updated")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	score.text = str(WorldData.battle_score)
	score.rect_pivot_offset.y = score.rect_size.y/2
	score.rect_pivot_offset.x = 5 #not a typo

func _on_battle_score_updated():
	score.text = str(WorldData.battle_score)
	score_animation_player.play("pulse")


func _on_battling_entered():
	score_animation_player.play("fade_in")


func _on_not_battling_entered():
	score_animation_player.play("fade_out")
