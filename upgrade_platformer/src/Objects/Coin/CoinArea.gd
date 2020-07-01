extends Area2D
class_name CoinArea

signal coin_collected
onready var coin_value: = WorldData.coin_value
onready var _coin_state_machine = $CoinStateMachine
onready var thwack_timer: = $CoinStateMachine/CoinThwacked/CoinThwackedTimer
onready var coin_ap: = get_parent().get_node("CoinAP")


func _ready():
	thwack_timer.connect("timeout", self, "_on_coin_timer_timeout")

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("PLAYER"):
		collect_coin()


func collect_coin():
	WorldData.battle_score += coin_value
	WorldData.score += coin_value
	owner.queue_free()
	emit_signal("coin_collected")



func _on_area_entered(area):
	if area.is_in_group("THWACK"):
		_coin_state_machine.transition_to("CoinThwacked", {"thwack_direction" : area.get_parent().get_thwack_direction()} )
	coin_ap.stop()


func _on_coin_timer_timeout():
#	coin_ap.play("coin_bob") #Need to pass last position info around in statemachine to do this
	collect_coin()
