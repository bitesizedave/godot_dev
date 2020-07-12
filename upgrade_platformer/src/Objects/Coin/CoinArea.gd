extends Area2D
class_name CoinArea

signal coin_collected
signal you_got_coin_thwacked

onready var coin_value: = WorldData.coin_value
onready var _coin_state_machine = $CoinStateMachine
onready var thwack_timer: = $CoinStateMachine/CoinThwacked/CoinThwackedTimer
onready var coin_ap: = get_parent().get_node("CoinAP")
onready var thwack_acceleration: = CoinData.thwack_acceleration
var consecutive_thwacks: int
var consecutive_thwack_value = 1
onready var thwack_score_added: = CoinData.thwack_score_added
var thwack_instance_id: int

func _ready():
	thwack_timer.connect("timeout", self, "_on_coin_timer_timeout")

#func _on_body_entered(body: PhysicsBody2D) -> void:
#	if body.is_in_group("PLAYER"):
#		collect_coin()
#	if body.is_in_group("COINS"):
#		collect_coin()
#	if body.is_in_group("JUMP_THROUGH"):
#		pass


func collect_coin():
	WorldData.battle_score += coin_value
	WorldData.score += coin_value
	owner.queue_free()
	emit_signal("coin_collected")



func _on_area_entered(area):
	if _coin_state_machine.state.name == "CoinThwacked":
		connect("you_got_coin_thwacked", area, "_on_you_got_coin_thwacked")
		emit_signal("you_got_coin_thwacked", area)
	if area.is_in_group("THWACK"):
		_coin_state_machine.transition_to("CoinThwacked", {"thwack_direction" : area.get_parent().get_thwack_direction(),
			"consecutive_thwack_value" : consecutive_thwack_value, "thwack_instance_id" : area.get_instance_id()})
	if area.is_in_group("PLAYER"):
		collect_coin()
	if area.is_in_group("COIN") and area.get_instance_id() != self.get_instance_id() :
		collect_coin()
	coin_ap.stop()


func _on_coin_timer_timeout():
#	coin_ap.play("coin_bob") #Need to pass last position info around in statemachine to do this
	consecutive_thwack_value = 1
	collect_coin()


func _on_you_got_thwacked(area, thwack_id):
	if thwack_instance_id == thwack_id:
		collect_coin()
	if (area == self and thwack_instance_id != thwack_id):
		WorldData.battle_score += thwack_score_added
		WorldData.score += thwack_score_added
		consecutive_thwack_value += 1
	thwack_instance_id = thwack_id


func _on_you_got_coin_thwacked(area):
	if area == self:
		collect_coin()

func get_consecutive_thwack_value():
	return consecutive_thwack_value
