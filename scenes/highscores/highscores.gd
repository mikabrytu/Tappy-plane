extends Control


@export var line_scene: PackedScene


# Godot Messages


func _ready():
	Leaderboard.connect("list_loaded", _on_list_loaded)
	Leaderboard.auth_user()


# Listeners


func _on_list_loaded(dict):
	for key in dict:
		var l = line_scene.instantiate()
		l.get_child(0).text = key
		l.get_child(1).text = str(dict[key])
		
		$VBoxContainer.add_child(l)


func _on_submit_score_pressed():
#	Leaderboard.post_score(GameManager.get_highscore())
	Leaderboard.get_highscore()
