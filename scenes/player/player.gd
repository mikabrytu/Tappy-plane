extends RigidBody2D


signal die

@export var fly_impulse: float = 750.0
@export var min_fall_velocity: float = 300.0
@export var min_angle: float = 30.0 # Positive angles are actually aiming down and vice versa
@export var max_angle: float = -30.0


# Godot Messages


func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed():
			_fly()


# Implementation


func _fly():
	if (linear_velocity.y < min_fall_velocity):
		return
	
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2.UP * fly_impulse, Vector2.ZERO)
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("bump_up")


func _die():
	die.emit()
	queue_free()


# Listeners


func _on_obstacle_collision_entered():
	_die()


func _on_ground_entered(body):
	_die()
