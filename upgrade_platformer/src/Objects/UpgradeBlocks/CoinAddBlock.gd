extends StaticBody2D

onready var add_area = $AddArea
onready var subtract_area = $SubtractArea
onready var level_label = $LevelLabel
onready var cost_label = $CostLabel
var points_spent: int
var starting_cost: = 10
var cost: int
var cost_ramp: = 2.5
var level: = 1

func _ready():
	add_area.connect("area_entered", self, "_on_add_area_entered")
	subtract_area.connect("area_entered", self, "_on_subtract_area_entered")
	level = WorldData.start_coins
	if level == 1:
		cost = starting_cost
	else: cost *= cost_ramp * level
	level_label.text = str(level)
	cost_label.text = str("$",cost)

func _on_subtract_area_entered(area):
	if area.is_in_group("THWACK"):
		if level > 1:
			WorldData.score += cost
			points_spent -= cost
			level -= 1
			WorldData.set_start_coins(level)
			cost = cost/cost_ramp
			level_label.text = str(level)
			cost_label.text = str("$",cost)


func _on_add_area_entered(area):
	if (area.is_in_group("THWACK")
		or area.is_in_group("PLAYER")):
		if WorldData.score >= cost:
			WorldData.score -= cost
			points_spent += cost
			level += 1
			WorldData.set_start_coins(level)
			cost *= cost_ramp
			level_label.text = str(level)
			cost_label.text = str("$",cost)



