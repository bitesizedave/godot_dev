extends CanvasLayer



func _on_NotBattling_entered():
	$BackgroundRect.modulate = Color.darkcyan


func _on_Battling_entered():
	$BackgroundRect.modulate = Color.black
