extends Node2D


signal collected

@export var spawn_position: Marker2D
@export var spawn_offset = Vector2(100.0, 700.0)
@export var min_max_timer = Vector2(2.0, 5.0)

var _power_ups: Array = [
	preload("res://scenes/power_ups/coin.tscn")
]


# Godot Messages


func _ready():
	_set_random_wait_time()
	$Timer.start()


# Implementation


func _new_power_up():
	var pu_position = spawn_position.position
	pu_position.y += randf_range(spawn_offset.x, spawn_offset.y)
	
	var pu = _power_ups.pick_random().instantiate()
	pu.position = pu_position
	pu.connect("hit", _on_power_up_hit)
	
	add_child(pu)


func _set_random_wait_time():
	var time = randi_range(min_max_timer.x, min_max_timer.y)
	$Timer.wait_time = time


# Listeners


func _on_timer_timeout():
	_new_power_up()
	_set_random_wait_time()


func _on_power_up_hit():
	collected.emit()
