class_name Enemy2
extends Enemy


@export var ping_pong_coords: Vector2

var _is_shooting: bool = false

const UP = Vector2(-0.25, -1)
const DOWN = Vector2(-0.25, 1)


# Godot Messages


func _ready():
	$"Movement System".direction = DOWN


func _process(delta):
	if position.y < ping_pong_coords.x:
		$"Movement System".direction = DOWN
	if position.y > ping_pong_coords.y:
		$"Movement System".direction = UP
	
	if target != null:
		if (not _is_shooting 
			and (global_position.x - target.global_position.x) < distance
		):
			_is_shooting = true
			shoot()
			$"Shoot Timer".start()


# Listeners


func _on_shoot_timer_timeout():
	can_shoot = true
	shoot()
