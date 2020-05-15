extends Position2D

var grid_size: = Vector2()
var grid_position: = Vector2()
var zoom_level: = Vector2()

onready var parent = get_parent()

func _ready() -> void:
	grid_size = OS.get_real_window_size()
	set_as_toplevel(true)
	update_grid_position()
	
func _physics_process(delta: float) -> void:
	update_grid_position()

func update_grid_position():
	var x = round(parent.position.x/grid_size.x)
	var y = round(parent.position.y/grid_size.y)
	var new_grid_position = Vector2(x,y)
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	self.position = grid_position * grid_size

