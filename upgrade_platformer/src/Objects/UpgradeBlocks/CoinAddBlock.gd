extends StaticBody2D

onready var add_area = $AddArea
onready var add_area_shape = $AddArea/AddShape
onready var subtract_area = $SubtractArea
onready var subtract_area_shape = $SubtractArea/SubtractShape
onready var level_label = $LevelLabel
onready var cost_label = $CostLabel
var points_spent: int
var starting_cost: = 1
var cost: float
var cost_ramp: = 2
var level: = 1
var attack_direction: Vector2

func _ready():
	add_area.connect("area_entered", self, "_on_add_area_entered")
	add_area.connect("area_exited", self, "_on_add_area_exited")
	subtract_area.connect("area_entered", self, "_on_subtract_area_entered")
	subtract_area.connect("area_exited", self, "_on_subtract_area_exited")
	level = WorldData.start_coins
	if level == 1:
		cost = starting_cost
	else: cost *= cost_ramp * level
	level_label.text = str(level)
	cost_label.text = str("$",cost)


func _on_you_got_thwacked(area, thwack_id, attack_dir):
	attack_direction = attack_dir
	if attack_dir.y == 1:
		add_area_shape.disabled = true
	else:
		subtract_area_shape.disabled = true

func _on_subtract_area_entered(area):
	if area.is_in_group("THWACK"):
		area.connect("you_got_thwacked", self, "_on_you_got_thwacked")
		area.timer.connect("timeout", self, "_on_thwack_timeout")
		if (level > 1
			and attack_direction.y == 1):
			WorldData.score += cost
			points_spent -= cost
			level -= 1
			WorldData.set_start_coins(level)
			cost = round(cost/cost_ramp)
			level_label.text = str(level)
			cost_label.text = str("$",cost)



func _on_subtract_area_exited(area):
	pass

func _on_add_area_entered(area):
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
				WorldData.set_start_coins(level)
				cost = round(cost * cost_ramp)
				level_label.text = str(level)
				cost_label.text = str("$",cost)



func _on_add_area_exited(area):
	pass


func _on_thwack_timeout():
	subtract_area_shape.disabled = false
	add_area_shape.disabled = false
