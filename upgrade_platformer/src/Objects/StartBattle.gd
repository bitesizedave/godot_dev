extends Area2D

onready var game_state_machine = get_parent().owner.get_node("../GameStateMachine")


#func _on_StartBattle_area_entered(area):
#	queue_free()
#	game_state_machine.transition_to("Battling")


func _on_area_shape_entered(area_id, area, area_shape, self_shape):
	queue_free()
	game_state_machine.transition_to("Battling")
