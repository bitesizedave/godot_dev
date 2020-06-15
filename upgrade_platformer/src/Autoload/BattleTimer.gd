extends Node

onready var timer = $Timer
const BATTLE_TIME: = 60

func _ready():
	timer.wait_time = BATTLE_TIME
	timer.one_shot = true
	start_battle_timer()

func start_battle_timer():
	timer.start()

func get_battle_time_left() -> float:
	return timer.time_left
