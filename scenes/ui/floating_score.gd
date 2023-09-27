extends Label


@export var height: float = 10.0
@export var duration: float = 0.5
@export var fade: float = 0.8


# Godot Messages


func _ready():
	hide()


# Public API


func play(score: int):
	text = "+" + str(score)
	
	show()
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2.UP * height, duration)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade)
