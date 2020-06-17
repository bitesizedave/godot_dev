extends Node
class_name GameStateMachine, "res://assets/icons/state_machine.svg"
"""
Generic State Machine. Initializes states and delegates engine callbacks
(_physics_process, _unhandled_input) to the active state.
"""


export var initial_game_state: = NodePath()

onready var game_state: GameState = get_node(initial_game_state) setget set_game_state
onready var _game_state_name: = game_state.name


func _init() -> void:
	add_to_group("game_state_machine")


func _ready() -> void:
	yield(owner, "ready")
	game_state.enter()


func _unhandled_input(event: InputEvent) -> void:
	game_state.unhandled_input(event)


func _physics_process(delta: float) -> void:
	game_state.physics_process(delta)


func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return

	var target_state: = get_node(target_state_path)

	game_state.exit()
	self.game_state = target_state
	game_state.enter(msg)


func set_game_state(value: GameState) -> void:
	game_state = value
	_game_state_name = game_state.name
