extends Area2D


signal hit

@export var speed = 100.0


# Godot Messages


func _process(delta):
	position += Vector2.LEFT * speed * delta


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	GameManager.increase_score()
	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	hit.emit()
	
	await get_tree().create_timer(0.66).timeout
	
	queue_free()
