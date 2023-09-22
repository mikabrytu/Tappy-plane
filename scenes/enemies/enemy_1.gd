class_name Enemy1
extends Area2D


@export var distance: float
@export var height_offset: Vector2


var _target: Node2D


# Godot Messages


func _process(delta):
	if _target != null:
		var offset = Vector2( 
			global_position.y + height_offset.x, 
			global_position.y + height_offset.y,
		)
		
		if (
			_target.global_position.y > offset.x 
			and _target.global_position.y < offset.y
		):
			print("Target in sight. Shoot!")


# Public API


func set_target(target):
	if target == null:
		return
	
	_target = target


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	queue_free()
