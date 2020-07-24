extends AddBlock


func _ready():
	
	starting_cost = 5
	cost_ramp = 2
	if level <= 1:
		level = 1
		cost = starting_cost
		print("cost ",cost)
	else: cost *= cost_ramp * level
	level_label.text = str(level)
	cost_label.text = str("$",cost)
	CoinData.start_coins = level
	print("coindata start_coins ",CoinData.start_coins)


func subtract_some_stuff():
	CoinData.start_coins -= 1



func add_some_stuff():
	CoinData.start_coins += 1
