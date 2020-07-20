extends AddBlock


func _ready():
	WorldData.start_coins = level
	starting_cost = 10
	cost_ramp = 5
	if level == 1:
		cost = starting_cost
	else: cost *= cost_ramp * level
	level_label.text = str(level)
	cost_label.text = str("$",cost)


# To be overwritten by children to give their specific blocks functionality
func subtract_some_stuff():
	WorldData.start_coins -= 1


# To be overwritten by children to give their specific blocks functionality
func add_some_stuff():
	WorldData.start_coins += 1
