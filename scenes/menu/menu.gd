extends Control


# Godot Messages


func _ready():
	$"Highscore Count".text = str(GameManager.get_highscore())


func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed():
			GameManager.load_scene(GameManager.GAME_SCENE)
