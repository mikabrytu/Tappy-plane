class_name Enemy1
extends Area2D


@export var distance: float
@export var height_offset: Vector2
@export var flee_duration: float


var _target: Node2D
var _origin: Vector2


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
	pass


func _flee():
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
	print("Enemy dead!")
	queue_free()
