extends Node2D


@export var enemies: Array[PackedScene]
@export var spawn_points: Array[Marker2D]
@export var player: Node2D

var _enemies_copy: Array[PackedScene]


# Godot Messages


func _ready():
	_enemies_copy.append(enemies[0])


# Implementation


func _new_enemy():
#	var e = _enemies_copy.pick_random().instantiate()
	var e = enemies[2].instantiate()
	var spawn = spawn_points.pick_random()
	
	e.set_target(player)
	e.set_origin(spawn.get_global_position())
	
	add_child(e)


# Listeners


func _on_start_spawn_timer_timeout():
	_new_enemy()
	$"Spawn Timer".start()
#	$"Dificulty Timer".start()


func _on_spawn_timer_timeout():
	_new_enemy()


func _on_dificulty_timer_timeout():
	if _enemies_copy.size() == enemies.size():
		return
	
	var index = _enemies_copy.size()
	_enemies_copy.append(enemies[index])
	
	$"Dificulty Timer".start()
