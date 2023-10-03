class_name Player
extends RigidBody2D


signal die

@export_category("Fly")
@export var fly_impulse: float = 750.0
@export var min_fall_velocity: float = 300.0
@export var max_height: float = 100.0
@export_category("Attack")
@export var attack_impulse: float = 750
@export var attack_rest_timer: float = 0.5
@export var reset_position_duration: float = 0.5
@export_category("Animation")
@export var min_angle: float = 30.0 # Positive angles are actually aiming down and vice versa
@export var max_angle: float = -30.0

var _original_gravity: float
var _is_attacking: bool = false


# Godot Messages


func _ready():
	_original_gravity = gravity_scale


func _process(_delta):
	if Input.is_action_just_pressed("click_left"):
		_fly()
	if Input.is_action_just_pressed("click_right"):
		_attack()


#func _input(event):
#	if event is InputEventMouseButton or event is InputEventScreenTouch:
#		if event.is_pressed():
#			_fly()


# Implementation


func _fly():
	if linear_velocity.y < min_fall_velocity:
		return
	
	if global_position.y < max_height:
		return
	
	linear_velocity = Vector2.ZERO
	apply_central_impulse(Vector2.UP * fly_impulse)
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("bump_up")


func _attack():
	if _is_attacking:
		return
	
	var reset_position = position
	
	$AnimationPlayer.play("attack")
	$"Attack Sound Timer".start()
	
	_is_attacking = true
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	apply_central_impulse(Vector2.RIGHT * attack_impulse)
	
	await get_tree().create_timer(attack_rest_timer).timeout
	
	reset_position.y = position.y
	var tween = create_tween()
	tween.tween_property(
		self, 
		"position", 
		reset_position, 
		reset_position_duration,
	).set_trans(
		Tween.TRANS_SINE
	).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_callback(_reset_physics)


func _reset_physics():
	linear_velocity = Vector2.ZERO
	gravity_scale = _original_gravity
	_is_attacking = false


func _die():
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
		$AnimationPlayer.play("idle")
		$"Player Spritesheet".rotation_degrees = 0
	
	$"Player Spritesheet".play("explosion")
	$Death.play()
	$CollisionShape2D.set_deferred("disabled", true)
	
	await get_tree().create_timer(1.35).timeout
	
	GameManager.reset_streak()
	die.emit()
	queue_free()


# Public API


func try_kill():
	if not _is_attacking:
		_die()


# Listeners


func _on_obstacle_collision_entered():
	_die()


func _on_ground_entered(_body):
	_die()


func _on_attack_sound_timer_timeout():
	$Attack.play()
