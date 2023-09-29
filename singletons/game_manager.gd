extends Node


signal score_updated(score)
signal streak_updated(streak)
signal streak_reset

const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MENU_SCENE: PackedScene = preload("res://scenes/menu/menu.tscn")
const HIGHSCORE_SCENE: PackedScene = preload("res://scenes/highscores/highscores.tscn")

const SAVE_FILE_PATH = "user://savedata.save"

var _score: int
var _streak: int
var _pending_score: int
var _trying_submit_score: bool = false


# Godot Messages


func _ready():
	reset_score()
	reset_streak()


# Scenes


func load_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)


# Streak


func increase_streak():
	_streak += 1
	streak_updated.emit(_streak)


func reset_streak():
	_streak = 0
	streak_reset.emit()


# Score


func reset_score():
	_score = 0


func increase_score(amount: int = 1):
	_score += amount
	score_updated.emit(_score)


func get_current_score() -> int:
	return _score


func update_userdata(username = "", score = 0, id = ""):
	if username == "" and score == 0 and id == "":
		return
	
	var data = _get_saved_data()
	
	if data.is_empty():
		_save_userdata(username, score, id)
		try_submit_score(score)
		return
	
	if username != "":
		data.username = username
	
	if score > data.score:
		data.score = score
		try_submit_score(score)
	
	if id != "":
		data.id = id
	
	_save_userdata(data.username, data.score, data.id)


func get_user_id() -> String:
	var data = _get_saved_data()
	
	if data.is_empty():
		return ""
	
	return data.id


func get_username() -> String:
	var data = _get_saved_data()
	
	if data.is_empty():
		return ""
	
	return data.username


func get_highscore() -> int:
	var data = _get_saved_data()
	
	if data.is_empty():
		return 0
	
	return data.score


# Implementation


func _save_userdata(username, score, id = ""):
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var data = {
		"id": id,
		"username": username,
		"score": score
	}
	
	if file == null:
		printerr("Save File not created")
		return
	
	file.store_line(JSON.stringify(data))
	file.close()


func _get_saved_data() -> Dictionary:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var json = JSON.new()
	
	if file == null:
		return {}
	
	var line = file.get_line()
	var err = json.parse(line)
	file.close()
	
	if err != OK:
		printerr(err)
		printerr(json.get_error_line())
		printerr(json.get_error_message())
		
		return {}
	
	return json.data


func try_submit_score(score):
	if not Leaderboard.is_authenticated():
		_trying_submit_score = true
		_pending_score = score
		
		Leaderboard.connect("auth_completed", _on_auth_completed)
		Leaderboard.auth_user()
	else:
		Leaderboard.post_score(score)


# Listeners


func _on_auth_completed():
	if (_trying_submit_score):
		Leaderboard.post_score(_pending_score)
		
		_pending_score = 0
		_trying_submit_score = false
