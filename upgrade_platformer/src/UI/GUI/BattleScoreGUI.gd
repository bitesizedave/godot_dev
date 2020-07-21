extends HBoxContainer

onready var score = $ScoreBox/ScoreLabel
onready var score_animation_player = $ScoreBox/ScoreLabel/ScoreLabelAnimationPlayer
var is_coin_collected: = false
var coin_tween_speed

func _ready():
	WorldData.connect("battle_score_updated", self, "_on_battle_score_updated")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	score.text = str(WorldData.battle_score)
	score.rect_pivot_offset.y = score.rect_size.y/2
	score.rect_pivot_offset.x = 5 #not a typo

func _on_battle_score_updated():
	score_animation_player.play("base")
	if is_coin_collected:
		yield(get_tree().create_timer(coin_tween_speed), "timeout")
		score.text = str(WorldData.battle_score)
		score_animation_player.play("pulse")
		is_coin_collected = false
	else: 
		score.text = str(WorldData.battle_score)
		score_animation_player.play("pulse")


func _on_battling_entered():
	score_animation_player.play("fade_in")


func _on_not_battling_entered():
	score_animation_player.play("base")
	score_animation_player.play("fade_out")


func _on_coin_collected(tween_speed):
	is_coin_collected = true
	coin_tween_speed = tween_speed
	
	
