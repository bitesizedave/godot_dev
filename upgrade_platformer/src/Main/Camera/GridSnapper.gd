extends Camera2D

var grid_size: = Vector2()
var grid_position: = Vector2() 
var _resetting: = false

onready var player: = get_node("../PlayerSquare")
#onready var grandparent = get_parent().get_owner()

func _ready() -> void:
	grid_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	set_as_toplevel(true)
	WorldData.connect("hard_reset", self, "_on_reset")
	
	
func _process(delta: float) -> void:
	if (not WorldData.wrapping and not _resetting):
			update_grid_position()

func update_grid_position():
	if (WorldData.is_in_right_room(player.position)):
		self.position = Vector2(ProjectSettings.get("display/window/size/width"), 0)
		WorldData.camera_position = self.position
	elif (WorldData.is_in_left_room(player.position)):
		self.position = Vector2(-ProjectSettings.get("display/window/size/width"), 0)
		WorldData.camera_position = self.position
	elif (WorldData.is_in_bottom_room(player.position)):
#	elif (player.position.y > WorldData.battle_room_dimensions.br_bottom):
		self.position = Vector2(0, ProjectSettings.get("display/window/size/height"))
		WorldData.camera_position = self.position
	elif (WorldData.is_in_top_room(player.position)):
#	elif (player.position.y < WorldData.battle_room_dimensions.br_top):
		self.position = Vector2(0, -ProjectSettings.get("display/window/size/height"))
		WorldData.camera_position = self.position
	elif (WorldData.is_in_battle_room(player.position)
		and not WorldData.is_in_battle_room(self.position)): 
		self.position = Vector2(0.0, 0.0)
		WorldData.camera_position = self.position

