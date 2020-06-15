extends Area2D
class_name Coin

signal coin_collected

onready var coin_value: = WorldData.coin_value

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	WorldData.battle_score += coin_value
	queue_free()
	emit_signal("coin_collected")
