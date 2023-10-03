extends Area2D


signal hit
signal missed

@export var speed: float = 100.0
@export var value: int

var collected: bool = false


# Godot Messages


func _process(delta):
	position += Vector2.LEFT * speed * delta


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	if collected:
		return
	
	missed.emit()
	queue_free()


func _on_body_entered(_body):
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.hide()
	$"Floating Score".play(value)
	
	GameManager.increase_score(value)
	hit.emit()
	collected = true
	
	await get_tree().create_timer(1.5).timeout
	
	queue_free()
