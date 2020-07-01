extends Area2D
class_name ThwackArea, "res://assets/thwack.png"

onready var timer = $ThwackTimer
signal done_thwackin
signal you_got_thwacked

func _ready():
	timer.connect("timeout", self, "_on_thwack_timer_timeout")


func _on_thwack_timer_timeout():
	$ThwackAP.play("thwack_fade")
	emit_signal("done_thwackin")