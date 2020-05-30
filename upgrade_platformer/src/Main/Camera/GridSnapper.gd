extends Position2D

var grid_size: = Vector2()
var grid_position: = Vector2() 

onready var player: = get_node("../PlayerSquare")
#onready var grandparent = get_parent().get_owner()

func _ready() -> void:
	grid_size = OS.get_real_window_size()
	set_as_toplevel(true)
#	update_grid_start_position()
	
func _physics_process(delta: float) -> void:
	if !WorldData.wrapping: update_grid_position()

func update_grid_position():
	var x = round(player.position.x/grid_size.x)
	var y = round(player.position.y/grid_size.y)
	var new_grid_position = Vector2(x,y)
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	self.position = grid_position * grid_size
	WorldData.camera_position = self.position
	print(new_grid_position.x,new_grid_position)
	
#func update_grid_start_position():
#	var x = round(grandparent.position.x/grid_size.x)
#	var y = round(grandparent.position.y/grid_size.y)
#	var new_grid_position = Vector2(x,y)
#	if grid_position == new_grid_position:
#		return
#	grid_position = new_grid_position
#	self.position = grid_position * grid_size
#	WorldData.camera_position = self.position
	



