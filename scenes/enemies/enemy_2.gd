class_name Enemy2
extends Enemy


@export var ping_pong_coords: Vector2

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


# Listeners


func _on_shoot_timer_timeout():
	can_shoot = true
	shoot()
