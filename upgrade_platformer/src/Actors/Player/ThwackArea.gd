extends Area2D
class_name ThwackArea, "res://assets/thwack.png"

onready var timer = $ThwackTimer
onready var thwack_state = get_parent()
signal done_thwackin
signal you_got_thwacked

func _ready():
	timer.connect("timeout", self, "_on_thwack_timer_timeout")


func _on_thwack_timer_timeout():
	$ThwackAP.play("thwack_fade")
	emit_signal("done_thwackin")


func _on_area_entered(area):
	connect("you_got_thwacked", area, "_on_you_got_thwacked")
	thwack_state.thwacked_something = true
	emit_signal("you_got_thwacked", area, self.get_instance_id())


func _on_area_exited(area):
	thwack_state.thwacked_something = false

