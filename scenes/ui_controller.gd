extends CanvasLayer


@export_category("Tween values")
@export var punch_strength: float
@export var punch_duration: float


# Godot Messages


func _ready():
	GameManager.connect("score_updated", _on_score_updated)
	
	$"Game Over/HBoxContainer/Retry".connect("pressed", _on_retry_pressed)
	$"Game Over/HBoxContainer/Highscore".connect("pressed", _on_highscore_pressed)
	
	_set_game_hud()


# Implementation


func _set_game_hud():
	$"Game Hud".show()
	$"Game Over".hide()


func _set_game_over_hud():
	var session_score = GameManager.get_current_score()
	
	$"Game Over/Score".text = "Score: " + str(session_score)
	
	$"Game Hud".hide()
	$"Game Over/HBoxContainer".hide()
	$"Game Over".show()
	
	var username = GameManager.get_username()
	if username == "":
		# TODO: Ask for player name
		username = "godot-test" # This is a hack. Should be replaced by user input
	
	GameManager.update_userdata(username, session_score)
	GameManager.reset_score()
	
	await get_tree().create_timer(1.5).timeout
	
	$"Game Over/HBoxContainer".show()


# Listeners


func _on_player_die():
	_set_game_over_hud()


func _on_retry_pressed():
	get_tree().reload_current_scene()


func _on_highscore_pressed():
	GameManager.load_scene(GameManager.HIGHSCORE_SCENE)


func _on_score_updated(score):
	var punch = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	punch.tween_property(
		$"Game Hud/Score", 
		"scale", 
		Vector2.ONE, 
		punch_duration
	).from(Vector2.ONE * punch_strength)
	
	$"Game Hud/Score".text = "Score: " + str(score)
