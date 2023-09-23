class_name Enemy1
extends Area2D


@export var distance: float
@export var height_offset: Vector2
@export var flee_duration: float
@export_category("Bullet")
@export var bullet_scene: PackedScene
@export var bullet_spawn: Marker2D

var _target: Node2D
var _origin: Vector2
var _can_shoot: bool = true
var _is_exploding: bool = false


# Godot Messages


func _process(delta):
	if _target != null:
		var offset = Vector2( 
			global_position.y + height_offset.x, 
			global_position.y + height_offset.y,
		)
		
		if (global_position.x - _target.global_position.x) < distance:
			if (
				_target.global_position.y > offset.x 
				and _target.global_position.y < offset.y
			):
				_attack()
				_flee()


# Implementation


func _attack():
	if not _can_shoot:
		return
	
	_can_shoot = false
	
	var b = bullet_scene.instantiate()
	get_tree().root.add_child.call_deferred(b)
	b.setup(bullet_spawn, Vector2.LEFT, collision_layer)


func _flee():
	if _is_exploding:
		return
	
	$VisibleOnScreenNotifier2D.position.x = -60
	$"Movement System".can_move(false)
	
	var tween = create_tween()
	tween.tween_property(self, "position", _origin, flee_duration)


# Public API


func set_target(target):
	if target == null:
		return
	
	_target = target


func set_origin(origin):
	_origin = origin
	position = origin


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var layer = body.collision_layer
	var score = 0
	
	if layer == 1:
		score = 3
	elif layer == 5:
		score = 1
	
	GameManager.increase_score(score)
	$AnimatedSprite2D.play("explosion")
	_is_exploding = true
	
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
