extends Area2D


signal hit
signal missed

@export var speed: float = 100.0
@export var value: int


# Godot Messages


func _process(delta):
	position += Vector2.LEFT * speed * delta


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	missed.emit()
	queue_free()


func _on_body_entered(_body):
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.hide()
	
	GameManager.increase_score(value)
	hit.emit()
	
	await get_tree().create_timer(1.5).timeout
	
	queue_free()
