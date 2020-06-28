extends Area2D

onready var game_state_machine = get_parent().owner.get_node("../GameStateMachine")

func _on_StartBattle_body_entered(body):
	queue_free()
#	GameStateData.set_game_state(GameStateData.BATTLING)
	game_state_machine.transition_to("Battling")
