extends AddBlock


func _ready():
	starting_cost = 5
	cost_ramp = 1.1
	if level <= 1:
		level = 1
		cost = starting_cost
	level_label.text = str(level)
	cost_label.text = str("$",cost)
	CoinData.start_coins = level


func subtract_some_stuff():
	CoinData.start_coins -= 1



func add_some_stuff():
	CoinData.start_coins += 1
