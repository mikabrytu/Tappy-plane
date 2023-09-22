extends Node2D


@export var enemies: Array[PackedScene]
@export var spawn_points: Array[Marker2D]
@export var player: Node2D


# Implementation


func _new_enemy():
	var e = enemies.pick_random().instantiate()
	var spawn = spawn_points[2]
	
	e.set_target(player)
	e.position = spawn.get_global_position()
	
	add_child(e)


# Listeners


func _on_start_spawn_timer_timeout():
	_new_enemy()
	$"Spawn Timer".start()


func _on_spawn_timer_timeout():
	_new_enemy()
