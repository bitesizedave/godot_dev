extends StaticBody2D
class_name AddBlock

onready var add_area = $AddArea
onready var add_area_shape = $AddArea/AddShape
onready var subtract_area = $SubtractArea
onready var subtract_area_shape = $SubtractArea/SubtractShape
onready var level_label = $LevelLabel
onready var cost_label = $CostLabel
onready var block_animation = $AddBlockAP
var points_spent: int
var starting_cost: int
var cost: float
var cost_ramp: float
var level: int
var attack_direction: Vector2
var save_dictionary: Dictionary

func _ready():
	add_area.connect("area_entered", self, "_on_add_area_entered")
	add_area.connect("area_exited", self, "_on_add_area_exited")
	subtract_area.connect("area_entered", self, "_on_subtract_area_entered")
	subtract_area.connect("area_exited", self, "_on_subtract_area_exited")
	WorldData.connect("hard_reset", self, "_on_hard_reset")
	save_persist_state()


func _on_you_got_thwacked(area, thwack_id, attack_dir):
	attack_direction = attack_dir
	if attack_dir.y == 1:
		add_area_shape.disabled = true
	else:
		subtract_area_shape.disabled = true


func _on_thwack_timeout():
	subtract_area_shape.disabled = false
	add_area_shape.disabled = false



func _on_subtract_area_entered(area):
	block_animation.seek(0.0)
	if area.is_in_group("THWACK"):
		area.connect("you_got_thwacked", self, "_on_you_got_thwacked")
		area.timer.connect("timeout", self, "_on_thwack_timeout")
		if (level > 1
			and attack_direction.y == 1):
			WorldData.score += cost
			points_spent -= cost
			level -= 1
			subtract_some_stuff()
			block_animation.play("subtract_block_bounce")
			cost = round(cost/cost_ramp)
			level_label.text = str(level)
			cost_label.text = str("$",cost)
			save_persist_state()



func _on_subtract_area_exited(area):
	pass

func _on_add_area_entered(area):
	block_animation.seek(0.0)
	if (area.is_in_group("THWACK")
		or area.is_in_group("PLAYER")):
		if area.is_in_group("THWACK"):
			area.connect("you_got_thwacked", self, "_on_you_got_thwacked")
			area.timer.connect("timeout", self, "_on_thwack_timeout")
		if attack_direction.y != 1:
			if WorldData.score >= cost:
				WorldData.score -= cost
				points_spent += cost
				level += 1
				add_some_stuff()
				block_animation.play("add_block_bounce")
				cost = round(cost * cost_ramp)
				level_label.text = str(level)
				cost_label.text = str("$",cost)
				save_persist_state()



func _on_add_area_exited(area):
	pass

# Functions belod to be overwritten by children to give their specific blocks functionality
func subtract_some_stuff():
	#Make sure this is being saved!
	pass


func add_some_stuff():
	pass


func save_persist_state():
	save_dictionary =  {
		"object_name" : self.name,
		"object_path" : self.get_path(),
		"points_spent" : points_spent,
		"starting_cost" : starting_cost,
		"cost" : cost,
		"cost_ramp" : cost_ramp,
		"level" : level
	}


func load_persist_state(load_dictionary: Dictionary):
	if (load_dictionary.object_name == self.name
		and load_dictionary.object_path == self.get_path()):
		points_spent = load_dictionary.points_spent
		starting_cost = load_dictionary.starting_cost
		cost = load_dictionary.cost
		cost_ramp = load_dictionary.cost_ramp
		level = load_dictionary.level
		print(name," loaded, cost ", cost, " level ", level)


func get_save_dictionary() -> Dictionary:
	return save_dictionary


func _on_hard_reset():
	level = 1
	level_label.text = str(level)
	cost = starting_cost
	cost_label.text = str("$",cost)
	save_persist_state()
