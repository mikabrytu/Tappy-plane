extends Area2D


signal hit(body)

@export var speed: float = 100.0


# Godot Messages


func _process(delta):
	position += Vector2.LEFT * speed * delta


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	hit.emit(body)
