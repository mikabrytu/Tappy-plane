extends Control


# Godot Messages


func _ready():
	$"Score Line/Highscore Count".text = str(GameManager.get_highscore())


func _on_play_pressed():
	GameManager.load_scene(GameManager.GAME_SCENE)


func _on_highscore_pressed():
	GameManager.load_scene(GameManager.HIGHSCORE_SCENE)
