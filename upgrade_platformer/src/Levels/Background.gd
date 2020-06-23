extends CanvasLayer

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	GameStateData.connect("battling_entered", self, "_on_battling_entered")

func _on_not_battling_entered():
	$BackgroundRect.modulate = Color.darkcyan


func _on_battling_entered():
	$BackgroundRect.modulate = Color.black
