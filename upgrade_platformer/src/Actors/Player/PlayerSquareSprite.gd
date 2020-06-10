extends Sprite

onready var dash_state = $PlayerSquare/StateMachine/Attack/Dash

func ready():
	dash_state.connect("dash_started", self, "_on_dash_started")
	dash_state.connect("dash_ended", self, "_on_dash_ended")


func _on_dash_started():
	self_modulate = Color.skyblue


func _on_dash_ended():
	self_modulate = Color.white


