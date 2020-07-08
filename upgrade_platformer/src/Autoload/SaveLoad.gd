extends Node

var savefile = "user://savefile.save"
var score_timer_wait_time: float
var game_started_epoch: int
var loaded_save_epoch: int
var first_save_epoch: int
var last_save_epoch: int
var total_number_of_saves: int
var number_of_saves_this_session: int
var time_away_in_seconds: int
var time_away_score_timer_cycles: float
onready var score_timer: Timer = $ScoreTimer

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	ScoreTimer.connect("timeout", self, "_on_score_timer_timeout")
	print("game loaded: ", load_game())
	if (last_save_epoch != loaded_save_epoch
		and loaded_save_epoch != 0): 
			_add_time_away_points()
			loaded_save_epoch = OS.get_unix_time()
	if total_number_of_saves == 0:
		game_started_epoch = OS.get_unix_time()
	print("game_started_epoch: ", game_started_epoch)

func _on_not_battling_entered():
	save_game()


func save_game() -> bool:
	total_number_of_saves += 1
	number_of_saves_this_session += 1
	if total_number_of_saves == 1:
		first_save_epoch = OS.get_unix_time()
		print("first_save_epoch: ", first_save_epoch)
	if number_of_saves_this_session == 1:
		loaded_save_epoch = OS.get_unix_time()
	else: last_save_epoch = OS.get_unix_time()
	var save_game = File.new()
	save_game.open(savefile, File.WRITE)
	var save_dictionary: = {
		"score" : WorldData.score,
		"score_time" : ScoreTimer.score_time,
		"latest_battle_score" : ScoreTimer.latest_battle_score,
		"loaded_save_epoch" : loaded_save_epoch,
		"last_save_epoch" : last_save_epoch,
		"total_number_of_saves" : total_number_of_saves,
		"first_save_epoch" : first_save_epoch,
		"game_started_epoch" : game_started_epoch
	}
	save_game.store_var(save_dictionary)
	save_game.close()
	return true


func load_game() -> bool:
	var loadfile = File.new()
	if loadfile.file_exists(savefile):
		loadfile.open(savefile, File.READ)
	else: 
		print("initializing savefile")
		save_game()
	var load_dictionary = loadfile.get_var()
	loadfile.close()
	if load_dictionary.has("score"):
		WorldData.score = load_dictionary.score
	else: 
		print("no score in savefile")
		return false
	if load_dictionary.has("score_time"):
		ScoreTimer.score_time = load_dictionary.score_time
	else:
		print("no score_time in savefile")
		return false
	if load_dictionary.has("latest_battle_score"):
		ScoreTimer.latest_battle_score = load_dictionary.latest_battle_score
	else:
		print("no latest_battle_score in savefile")
		return false
	if load_dictionary.has("loaded_save_epoch"):
		loaded_save_epoch = load_dictionary.loaded_save_epoch
	else:
		print("no loaded_save_epoch")
		return false
	if load_dictionary.has("last_save_epoch"):
		last_save_epoch = load_dictionary.last_save_epoch
	else:
		print("no last_save_epoch")
		return false
	if load_dictionary.has("total_number_of_saves"):
		total_number_of_saves = load_dictionary.total_number_of_saves
	else:
		print("no total_number_of_saves")
		return false
	if load_dictionary.has("first_save_epoch"):
		first_save_epoch = load_dictionary.first_save_epoch
	else:
		print("no first_save_epoch")
		return false
	return true


func _on_score_timer_timeout():
	save_game()


func _add_time_away_points():
	print("first save epoch: ", loaded_save_epoch)
	print("last_save_epoch: ", last_save_epoch)
	time_away_in_seconds = last_save_epoch - loaded_save_epoch
	time_away_score_timer_cycles = (time_away_in_seconds/ScoreTimer.score_time)
	print("time away in seconds: ", time_away_in_seconds)
	print("score timer cycles: ", time_away_score_timer_cycles)
	print("latest_battle_score: ", ScoreTimer.latest_battle_score)
	var score_to_add: int = int(time_away_score_timer_cycles) * ScoreTimer.latest_battle_score
	WorldData.score += score_to_add
	print("score_to_add: ", score_to_add)
