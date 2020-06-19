extends Timer

const BATTLE_TIME: = 60

func _ready():
	wait_time = BATTLE_TIME
	one_shot = true
	start()

