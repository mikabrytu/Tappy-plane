extends RigidBody2D


signal die

@export_category("Fly")
@export var fly_impulse: float = 750.0
@export var min_fall_velocity: float = 300.0
@export_category("Attack")
@export var attack_impulse: float = 750
@export var attack_gravity: float = 1.5
@export var attack_rest_timer: float = 0.5
@export_category("Animation")
@export var min_angle: float = 30.0 # Positive angles are actually aiming down and vice versa
@export var max_angle: float = -30.0

var _original_gravity: float


# Godot Messages


func _ready():
	_original_gravity = gravity_scale


func _process(_delta):
	if Input.is_action_just_pressed("click_left"):
		_fly()
	if Input.is_action_just_pressed("click_right"):
		_attack()
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


#func _input(event):
#	if event is InputEventMouseButton or event is InputEventScreenTouch:
#		if event.is_pressed():
#			_fly()


# Implementation


func _fly():
	if (linear_velocity.y < min_fall_velocity):
		return
	
	linear_velocity = Vector2.ZERO
	apply_central_impulse(Vector2.UP * fly_impulse)
	
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("bump_up")


func _attack():
	linear_velocity = Vector2.ZERO
	gravity_scale = attack_gravity
	apply_central_impulse(Vector2.RIGHT * attack_impulse)
	
	await get_tree().create_timer(attack_rest_timer).timeout
	
	linear_velocity = Vector2.ZERO
	gravity_scale = _original_gravity


func _die():
	die.emit()
	queue_free()


# Listeners


func _on_obstacle_collision_entered():
	_die()


func _on_ground_entered(_body):
	_die()
