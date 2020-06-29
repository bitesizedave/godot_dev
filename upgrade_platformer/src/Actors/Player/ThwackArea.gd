extends Area2D

onready var timer = $ThwackTimer
signal done_thwackin
signal you_got_thwacked

func _ready():
	timer.connect("timeout", self, "_on_thwack_timer_timeout")


func _on_thwack_timer_timeout():
	$ThwackAP.play("thwack_fade")
	emit_signal("done_thwackin")


func _on_area_entered(area):
	print(get_parent().attack_direction)
	emit_signal("you_got_thwacked", area, get_parent().attack_direction)
