extends CanvasLayer


# Godot Messages


func _ready():
	GameManager.connect("score_updated", _on_score_updated)
	
	$"Game Over/Restart".connect("pressed", _on_retry_pressed)
	
	_set_game_hud()


# Implementation


func _set_game_hud():
	$"Game Hud".show()
	$"Game Over".hide()


func _set_game_over_hud():
	$"Game Over/Score".text = "Score: " + str(GameManager.get_score())
	$"Game Over/AudioStreamPlayer".play()
	
	$"Game Hud".hide()
	$"Game Over".show()


# Listeners


func _on_player_die():
	_set_game_over_hud()


func _on_retry_pressed():
	GameManager.try_save_highscore()
	GameManager.reset_score()
	get_tree().reload_current_scene()


func _on_score_updated(score):
	$"Game Hud/Score".text = "Score: " + str(score)
