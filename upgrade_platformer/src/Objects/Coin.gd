extends Area2D
class_name Coin

signal coin_collected
onready var coin_value: = WorldData.coin_value

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	collect_coin()


func collect_coin():
	WorldData.battle_score += coin_value
	WorldData.score += coin_value
	queue_free()
	emit_signal("coin_collected")
