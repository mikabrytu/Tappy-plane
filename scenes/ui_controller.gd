extends CanvasLayer


@export_category("Tween values")
@export var punch_strength: float
@export var punch_duration: float


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
	var punch = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	punch.tween_property(
		$"Game Hud/Score", 
		"scale", 
		Vector2.ONE, 
		punch_duration
	).from(Vector2.ONE * punch_strength)
	
	$"Game Hud/Score".text = "Score: " + str(score)
