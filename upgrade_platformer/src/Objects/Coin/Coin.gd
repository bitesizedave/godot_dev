extends Area2D
class_name Coin

signal coin_collected
onready var coin_value: = WorldData.coin_value
onready var _coin_state_machine = $CoinStateMachine


func _on_Coin_body_entered(body: PhysicsBody2D) -> void:
	collect_coin()


func collect_coin():
	WorldData.battle_score += coin_value
	WorldData.score += coin_value
	queue_free()
	emit_signal("coin_collected")


func _on_ThwackCollisionArea2D_area_shape_entered(area_id, area, area_shape, self_shape):
	print(" _on_ThwackCollisionArea2D_area_shape_entered")
	_coin_state_machine.transition_to("CoinThwacked", {"ThwackShape" : shape_owner_get_owner(shape_find_owner(area_shape))})
