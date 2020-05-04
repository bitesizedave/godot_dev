extends Area2D
class_name Coin, "res://assets/coin.png"

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	anim_player.play("fade_out")
