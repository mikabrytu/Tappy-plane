extends Node


signal score_updated(score)
signal streak_updated(streak)
signal streak_reset

const GAME_SCENE: PackedScene = preload("res://scenes/game.tscn")
const MENU_SCENE: PackedScene = preload("res://scenes/menu/menu.tscn")

const SAVE_FILE_PATH = "user://savedata.save"

var _score: int
var _streak: int


# Godot Messages


func _ready():
	reset_score()
	reset_streak()


# Public API


func load_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)


func get_score() -> int:
	return _score


func increase_score(amount: int = 1):
	_score += amount
	score_updated.emit(_score)


func reset_score():
	_score = 0


func try_save_highscore():
	var highscore = get_highscore()
	
	if _score > highscore:
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		file.store_16(_score)
		file.close()


func get_highscore() -> int:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var highscore = file.get_16()
	file.close()
	
	return highscore


func increase_streak():
	_streak += 1
	streak_updated.emit(_streak)


func reset_streak():
	_streak = 0
	streak_reset.emit()
