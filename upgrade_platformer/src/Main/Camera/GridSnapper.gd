extends Position2D

var grid_size: = Vector2()
var grid_position: = Vector2() 

onready var player: = get_node("../PlayerSquare")
#onready var grandparent = get_parent().get_owner()

func _ready() -> void:
	grid_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	set_as_toplevel(true)
#	update_grid_start_position()
	
func _physics_process(delta: float) -> void:
	if (not WorldData.wrapping):
			update_grid_position()

func update_grid_position():
	if player.position.x > WorldData.battle_room_dimensions.br_right:
		self.position = Vector2(ProjectSettings.get("display/window/size/width"), 0)
		WorldData.camera_position = self.position
	elif player.position.x < WorldData.battle_room_dimensions.br_left:
		self.position = Vector2(-ProjectSettings.get("display/window/size/width"), 0)
		WorldData.camera_position = self.position
	elif player.position.y > WorldData.battle_room_dimensions.br_bottom:
		self.position = Vector2(0, ProjectSettings.get("display/window/size/height"))
		WorldData.camera_position = self.position
	elif player.position.y < WorldData.battle_room_dimensions.br_top:
		self.position = Vector2(0, -ProjectSettings.get("display/window/size/height"))
		WorldData.camera_position = self.position
	else: 
		self.position = Vector2(0.0, 0.0)
		WorldData.camera_position = self.position

	



