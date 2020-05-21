extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("debug_die"):
		$Player.state_machine.transition_to('Die')
