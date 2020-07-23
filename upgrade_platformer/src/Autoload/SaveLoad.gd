extends Node

var savefile_directory_string = "user://savefile.save"
var score_timer_wait_time: float
var game_started_epoch: int
var loaded_save_epoch: int
var first_save_epoch: int
var last_save_epoch: int
var total_number_of_saves: int
onready var number_of_saves_this_session: int = 0
var time_away_in_seconds: int
var time_away_score_timer_cycles: float
var game_loaded: bool
var load_error: bool
var persisting_objects: Array
onready var score_timer: Timer = $ScoreTimer

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	ScoreTimer.connect("timeout", self, "_on_score_timer_timeout")
	var ready_epoch = OS.get_unix_time()
	game_loaded = load_game()
	print("game loaded: ", game_loaded)
	if (last_save_epoch != loaded_save_epoch
		and loaded_save_epoch != 0
		and total_number_of_saves > 0): 
			_add_time_away_points()
			loaded_save_epoch = ready_epoch
	if (total_number_of_saves == 0
		and not load_error):
		game_started_epoch = ready_epoch
		print("initializing game started epoch")
	print("game_started_epoch: ", game_started_epoch)
	if (total_number_of_saves == 1
	and number_of_saves_this_session == 1):
		first_save_epoch = ready_epoch
		print("initializing first_save_epoch: ", first_save_epoch)

#func _on_not_battling_entered():
#	save_game()


func save_game() -> bool:
	var save_game_epoch: = OS.get_unix_time()
	total_number_of_saves += 1
	number_of_saves_this_session += 1
	if number_of_saves_this_session == 1:
		loaded_save_epoch = save_game_epoch
	else: last_save_epoch = save_game_epoch
	var save_game = File.new()
	save_game.open(savefile_directory_string, File.WRITE)
	var persisting_objects = _get_persisting_objects()
	var save_dictionary: = {
		"score" : WorldData.score,
		"score_time" : ScoreTimer.score_time,
		"latest_battle_score" : ScoreTimer.latest_battle_score,
		"loaded_save_epoch" : loaded_save_epoch,
		"last_save_epoch" : last_save_epoch,
		"total_number_of_saves" : total_number_of_saves,
		"first_save_epoch" : first_save_epoch,
		"game_started_epoch" : game_started_epoch,
		"persisting_objects" : persisting_objects
		
	}
	save_game.store_var(save_dictionary)
	save_game.close()
	return true


func load_game() -> bool:
	var loadfile = File.new()
	if loadfile.file_exists(savefile_directory_string):
		loadfile.open(savefile_directory_string, File.READ)
	else: 
		print("no savefile")
#		save_game()
		return false
		load_error = false
	var load_dictionary = loadfile.get_var()
	loadfile.close()
	if load_dictionary.has("score"):
		WorldData.score = load_dictionary.score
	else: 
		print("no score in savefile")
		load_error = true
		return false
	if load_dictionary.has("score_time"):
		ScoreTimer.score_time = load_dictionary.score_time
	else:
		print("no score_time in savefile")
		load_error = true
		return false
	if load_dictionary.has("latest_battle_score"):
		ScoreTimer.latest_battle_score = load_dictionary.latest_battle_score
	else:
		print("no latest_battle_score in savefile")
		load_error = true
		return false
	if load_dictionary.has("loaded_save_epoch"):
		loaded_save_epoch = load_dictionary.loaded_save_epoch
	else:
		print("no loaded_save_epoch")
		load_error = true
		return false
	if load_dictionary.has("last_save_epoch"):
		last_save_epoch = load_dictionary.last_save_epoch
	else:
		print("no last_save_epoch")
		load_error = true
		return false
	if load_dictionary.has("total_number_of_saves"):
		total_number_of_saves = load_dictionary.total_number_of_saves
		print("total_number_of_saves ",total_number_of_saves)
	else:
		print("no total_number_of_saves")
		load_error = true
		return false
	if load_dictionary.has("first_save_epoch"):
		first_save_epoch = load_dictionary.first_save_epoch
	else:
		print("no first_save_epoch")
		load_error = true
		return false
	if load_dictionary.has("game_started_epoch"):
		game_started_epoch = load_dictionary.game_started_epoch
	else:
		print("no game_started_epoch")
		load_error = true
		return false
	if load_dictionary.has("persisting_objects"):
		persisting_objects = load_dictionary.persisting_objects
	else:
		print("no persisting_objects")
		load_error = true
		return false
	if total_number_of_saves > 1:
		for dict in persisting_objects:
			var load_node = get_node(dict.get("object_path"))
			load_node.load_persist_state(dict)

	return true


func _on_score_timer_timeout():
	save_game()


func _add_time_away_points():
	print("first save epoch: ", loaded_save_epoch)
	print("last_save_epoch: ", last_save_epoch)
	time_away_in_seconds = last_save_epoch - loaded_save_epoch
	if ScoreTimer.score_time > 0.0:
		time_away_score_timer_cycles = (time_away_in_seconds/ScoreTimer.score_time)
	print("time away in seconds: ", time_away_in_seconds)
	print("score timer cycles: ", time_away_score_timer_cycles)
	print("latest_battle_score: ", ScoreTimer.latest_battle_score)
	var score_to_add: int = int(time_away_score_timer_cycles) * ScoreTimer.latest_battle_score
	if score_to_add < 0:
		print("ERROR NEGATIVE SCORE TO ADD DUDE!")
		return
	WorldData.score += score_to_add
	print("score_to_add: ", score_to_add)


func reset():
	score_timer_wait_time = 0.0
	game_started_epoch = 0
	loaded_save_epoch = 0
	first_save_epoch = 0
	last_save_epoch = 0
	total_number_of_saves = 0
	number_of_saves_this_session = 0
	time_away_in_seconds = 0
	time_away_score_timer_cycles = 0.0
#	save_game()
	var dir = Directory.new()
	var save_file_location = str(OS.get_user_data_dir(),"/savefile/save")
	print("removed save file: ", dir.remove(save_file_location))


func _get_persisting_objects() -> Array:
	var return_array = []
	var persist_group = get_tree().get_nodes_in_group("PERSIST")
	for node in persist_group:
		return_array.append(node.get_save_dictionary())
	return return_array
	
