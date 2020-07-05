extends Node

var savefile = "user://savefile.save"

func _ready():
	GameStateData.connect("not_battling_entered", self, "_on_not_battling_entered")
#	print("gameloaded: ",load_game())


func _on_not_battling_entered():
	save_game()


func save_game() -> bool:
	var save_game = File.new()
	save_game.open(savefile, File.WRITE)
	var save_dictionary: = {
		"score" : WorldData.score,
		"score_timer_time_left" : ScoreTimer.time_left,
		"score_time" : ScoreTimer.score_time,
		"latest_battle_score" : ScoreTimer.latest_battle_score
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
	if load_dictionary.has("score_timer_time_left"):
		ScoreTimer.start(-load_dictionary.score_timer_time_left)
	else:
		print("no score_timer_time_left in savefile")
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
	return true
