extends Node

var savefile = "user://savefile.save"
var score_timer_wait_time: float
var first_save_epoch: int
var last_save_epoch: int
var number_of_saves: int
var time_away_in_seconds: int
var time_away_score_timer_cycles: float
onready var score_timer: Timer = $ScoreTimer

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
	ScoreTimer.connect("timeout", self, "_on_score_timer_timeout")
	print("game loaded: ", load_game())
	if (last_save_epoch != first_save_epoch
		and first_save_epoch != 0.0): 
			_add_time_away_points()
			

func _on_not_battling_entered():
	save_game()


func save_game() -> bool:
	number_of_saves += 1
	if number_of_saves == 1:
		first_save_epoch = OS.get_unix_time()
	else: last_save_epoch = OS.get_unix_time()
	var save_game = File.new()
	save_game.open(savefile, File.WRITE)
	var save_dictionary: = {
		"score" : WorldData.score,
		"score_time" : ScoreTimer.score_time,
		"latest_battle_score" : ScoreTimer.latest_battle_score,
		"first_save_epoch" : first_save_epoch,
		"last_save_epoch" : last_save_epoch
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
	if load_dictionary.has("first_save_epoch"):
		first_save_epoch = load_dictionary.first_save_epoch
	else:
		print("no first_save_epoch")
		return false
	if load_dictionary.has("last_save_epoch"):
		last_save_epoch = load_dictionary.last_save_epoch
	else:
		print("no last_save_epoch")
		return false
	return true


func _on_score_timer_timeout():
	save_game()


func _add_time_away_points():
	print("first save epoch: ", first_save_epoch)
	print("last_save_epoch: ", last_save_epoch)
	time_away_in_seconds = last_save_epoch - first_save_epoch
	time_away_score_timer_cycles = (time_away_in_seconds/ScoreTimer.score_time)
	print("time away in seconds: ", time_away_in_seconds)
	print("score timer cycles: ", time_away_score_timer_cycles)
	print("latest_battle_score: ", ScoreTimer.latest_battle_score)
	var score_to_add: int = int(time_away_score_timer_cycles) * ScoreTimer.latest_battle_score
	WorldData.score += score_to_add
	print("score_to_add: ", score_to_add)
