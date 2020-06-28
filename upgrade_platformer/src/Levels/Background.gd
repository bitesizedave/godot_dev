extends CanvasLayer

onready var background_rect_ap = $BackgroundRect/BackgroundRectAP

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")

func _on_not_battling_entered():
	background_rect_ap.play("fade_to_blue")


func _on_battling_entered():
	background_rect_ap.play("fade_to_black")
