extends Control


@export var line_scene: PackedScene


# Godot Messages


func _ready():
	Leaderboard.connect("auth_completed", _on_auth_completed)
	Leaderboard.connect("list_loaded", _on_list_loaded)
	Leaderboard.auth_user()
	
	$"Loading Animation".show()
	$List.hide()
	
	$HBoxContainer/Score.text = str(GameManager.get_highscore())


# Listeners


func _on_auth_completed():
	Leaderboard.get_highscore()


func _on_list_loaded(dict):
	for key in dict:
		var l = line_scene.instantiate()
		l.get_child(0).text = key
		l.get_child(1).text = str(dict[key])
		
		$List.add_child(l)
	
	$"Loading Animation".hide()
	$List.show()


func _on_play_pressed():
	GameManager.load_scene(GameManager.GAME_SCENE)
