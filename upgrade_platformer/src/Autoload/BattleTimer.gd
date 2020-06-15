extends Node

onready var timer = $Timer
const BATTLE_TIME: = 60

func _ready():
	timer.wait_time = BATTLE_TIME
	timer.one_shot = true


