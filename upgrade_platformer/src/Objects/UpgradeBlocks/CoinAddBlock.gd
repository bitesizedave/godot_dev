extends AddBlock


func _ready():
	WorldData.start_coins = level


# To be overwritten by children to give their specific blocks functionality
func subtract_some_stuff():
	WorldData.start_coins -= 1


# To be overwritten by children to give their specific blocks functionality
func add_some_stuff():
	WorldData.start_coins += 1
