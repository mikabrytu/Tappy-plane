extends Node2D


signal collected

@export var spawn_position: Marker2D
@export var spawn_offset = Vector2(100.0, 700.0)
@export var min_max_timer = Vector2(2.0, 5.0)
@export var streak_threshold = Vector2(10, 30)

var _power_ups: Array = [
	preload("res://scenes/power_ups/coin_bronze.tscn"),
	preload("res://scenes/power_ups/coin_silver.tscn"),
	preload("res://scenes/power_ups/coin_gold.tscn")
]
var current_pu: PackedScene

# Godot Messages


func _ready():
	GameManager.connect("streak_updated", _on_streak_updated)
	
	current_pu = _power_ups[0]
	
	_set_random_wait_time()
	$Timer.start()


# Implementation


func _new_power_up():
	var pu_position = spawn_position.position
	pu_position.y += randf_range(spawn_offset.x, spawn_offset.y)
	
	var pu = current_pu.instantiate()
	pu.position = pu_position
	pu.connect("hit", _on_power_up_hit)
	pu.connect("missed", _on_power_up_missed)
	
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
	GameManager.increase_streak()


func _on_power_up_missed():
	GameManager.reset_streak()
	current_pu = _power_ups[0]


func _on_streak_updated(streak):
	if streak >= (streak_threshold.y * 2):
		current_pu = _power_ups[2]
		return
	
	if streak >= streak_threshold.x:
		current_pu = _power_ups[1]
		return
	
	current_pu = _power_ups[0]
