class_name Enemy1
extends Enemy


@export var distance: float
@export var height_offset: Vector2
@export var flee_duration: float


# Godot Messages


func _process(delta):
	if target != null:
		var offset = Vector2( 
			global_position.y + height_offset.x, 
			global_position.y + height_offset.y,
		)
		
		if (global_position.x - target.global_position.x) < distance:
			if (
				target.global_position.y > offset.x 
				and target.global_position.y < offset.y
			):
				shoot()
				_flee()


# Implementation


func _flee():
	if is_exploding:
		return
	
	$VisibleOnScreenNotifier2D.position.x = -60
	$"Movement System".can_move(false)
	
	var tween = create_tween()
	tween.tween_property(self, "position", origin, flee_duration)
