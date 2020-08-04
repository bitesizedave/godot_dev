extends AddBlock


func _ready():

	starting_cost = 100
	cost_ramp = 3
	if level <= 1:
		level = 1
		cost = starting_cost
	level_label.text = str(level)
	cost_label.text = str("$",cost)
	CoinData.coin_value = level


func subtract_some_stuff():
	CoinData.coin_collecting_coin_multiplier -= 1



func add_some_stuff():
	CoinData.coin_collecting_coin_multiplier += 1
