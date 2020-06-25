extends Area2D
class_name Coin

signal coin_collected
onready var coin_value: = WorldData.coin_value
onready var dash = get_tree().get_nodes_in_group("DASH")[0]

func _ready():
	dash.connect("raycast_hit", self, "_on_raycast_hit")

func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	collect_coin()


func _on_raycast_hit(object: Coin):
	if object == self:
		collect_coin()


func collect_coin():
	WorldData.battle_score += coin_value
	WorldData.score += coin_value
	queue_free()
	emit_signal("coin_collected")
