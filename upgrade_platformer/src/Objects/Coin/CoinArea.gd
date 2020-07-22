extends Area2D
class_name CoinArea

signal coin_collected
signal you_got_coin_thwacked

onready var coin_value: = WorldData.coin_value
onready var _coin_state_machine = $CoinStateMachine
onready var thwack_timer: = $CoinStateMachine/CoinThwacked/CoinThwackedTimer
onready var coin_ap: = get_parent().get_node("CoinAP")
onready var coin = get_parent()
onready var coin_sprite: = get_parent().get_node("CoinAreaDetector/CoinSprite")
onready var battle_score_gui
onready var thwack_acceleration: = CoinData.thwack_acceleration
var consecutive_thwacks: int
var consecutive_thwack_value = 1
onready var thwack_score_added: = CoinData.thwack_score_added
var thwack_instance_id: int
const COIN_LAYER: = 2
onready var tween_speed: = CoinData.coin_tween_speed


func _ready():
	thwack_timer.connect("timeout", self, "_on_coin_timer_timeout")
	battle_score_gui = coin.find_parent("MainLevel").find_node("BattleScore")
	connect("coin_collected", battle_score_gui, "_on_coin_collected")

func collect_coin():
	_coin_state_machine.transition_to("CoinStationary")
	var coin_tween = Tween.new()
	add_child(coin_tween)
	coin_tween.connect("tween_all_completed", self, "_on_coin_tween_completed")
	set_collision_layer_bit(COIN_LAYER, false)
	coin.remove_from_group("BATTLE_OBJECTS")
	coin_sprite.modulate.a = 0.8
	coin_tween.interpolate_property(coin, "global_position", global_position, 
		Vector2(WorldData.get_screen_left_edge()+10, WorldData.get_screen_top_edge()+30),
		tween_speed, Tween.TRANS_EXPO, Tween.EASE_IN)
	coin_tween.start()
	var coin_size_tween = Tween.new()
	add_child(coin_size_tween)
	coin_size_tween.interpolate_property(coin_sprite, "scale", coin_sprite.scale,
		coin_sprite.scale * 0.6, tween_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	coin_size_tween.start()
	emit_signal("coin_collected", tween_speed)
	WorldData.battle_score += coin_value
	WorldData.score += coin_value


func _on_coin_tween_completed():
	queue_free()


func _on_area_entered(area):
	if _coin_state_machine.state.name == "CoinThwacked":
		connect("you_got_coin_thwacked", area, "_on_you_got_coin_thwacked")
		emit_signal("you_got_coin_thwacked", area)
	if area.is_in_group("THWACK"):
		_coin_state_machine.transition_to("CoinThwacked", {"thwack_direction" : area.get_parent().get_thwack_direction(),
			"consecutive_thwack_value" : consecutive_thwack_value, "thwack_instance_id" : area.get_instance_id()})
	if area.is_in_group("PLAYER"):
		collect_coin()
	if area.is_in_group("COINS") and area.get_instance_id() != self.get_instance_id() :
		collect_coin()


func _on_coin_timer_timeout():
#	coin_ap.play("coin_bob") #Need to pass last position info around in statemachine to do this
	consecutive_thwack_value = 1
	collect_coin()


func _on_you_got_thwacked(area, thwack_id, attack_direction):
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
