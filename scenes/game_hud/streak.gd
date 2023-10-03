class_name Streak
extends Label


enum Level {
	LOW,
	MEDIUM,
	HIGH,
	NONE
}


@export var low_streak_color: Color
@export var medium_streak_color: Color
@export var high_streak_color: Color
@export var punch_strength: float
@export var punch_duration: float


# Godot Messages


func _ready():
	GameManager.connect("streak_updated", _on_streak_updated)
	GameManager.connect("streak_reset", _on_streak_reset)
	
	streak(0, Level.NONE)


# Public API


func streak(amount: int, level: Level):
	if level == Level.NONE:
		hide()
		return
	else:
		text = "x" + str(amount)
		show()
	
	if level == Level.LOW:
		$Sprite2D.modulate = low_streak_color
	if level == Level.MEDIUM:
		$Sprite2D.modulate = medium_streak_color
	if level == Level.HIGH:
		$Sprite2D.modulate = high_streak_color
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		$Sprite2D, 
		"scale", 
		Vector2.ZERO, 
		punch_duration
	).from(Vector2.ONE * punch_strength)


# Listeners


func _on_streak_updated(amount):
	var level = Streak.Level.NONE
	
	if amount > 2 and amount <= 5:
		level = Streak.Level.LOW
	if amount > 5 and amount <= 15:
		level = Streak.Level.MEDIUM
	if amount > 15:
		level = Streak.Level.HIGH
	
	streak(amount, level)


func _on_streak_reset():
	streak(0, Level.NONE)
