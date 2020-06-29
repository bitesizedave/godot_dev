extends Area2D

onready var timer = $ThwackTimer
signal done_thwackin

func _ready():
	timer.connect("timeout", self, "_on_thwack_timer_timeout")


func _on_thwack_timer_timeout():
	queue_free()
	emit_signal("done_thwackin")
