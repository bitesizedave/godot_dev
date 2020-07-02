extends Area2D
class_name CoinArea

signal coin_collected
onready var coin_value: = WorldData.coin_value
onready var _coin_state_machine = $CoinStateMachine
onready var thwack_timer: = $CoinStateMachine/CoinThwacked/CoinThwackedTimer
onready var coin_ap: = get_parent().get_node("CoinAP")
onready var thwack_acceleration: = CoinData.thwack_acceleration
var consecutive_thwacks: int
var consecutive_thwack_value = 0

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
		_coin_state_machine.transition_to("CoinThwacked", {"thwack_direction" : area.get_parent().get_thwack_direction(),
			"consecutive_thwack_value" : consecutive_thwack_value} )
	coin_ap.stop()


func _on_coin_timer_timeout():
#	coin_ap.play("coin_bob") #Need to pass last position info around in statemachine to do this
	consecutive_thwack_value = 0
	collect_coin()


func _on_you_got_thwacked(area):
	if area == self:
		WorldData.battle_score += consecutive_thwack_value
		WorldData.score += consecutive_thwack_value
		consecutive_thwack_value += 1


func get_consecutive_thwack_value():
	return consecutive_thwack_value
