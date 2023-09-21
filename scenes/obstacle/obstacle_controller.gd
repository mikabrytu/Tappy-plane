extends Node2D


signal collision_entered

@export var obstacle_scene: PackedScene
@export var bottom_spawn_position: Marker2D
@export var top_spawn_position: Marker2D
@export var spawn_offset: Vector2 = Vector2(100.0, 100.0)


# Godot Messages


# Implementation


func _new_obstacle():
	var o = obstacle_scene.instantiate()
	var side = randi_range(0, 1) # 0 is up, 1 is down
	var spawn = top_spawn_position if side == 0 else bottom_spawn_position
	var offset = Vector2(
			randf_range(0, spawn_offset.x),
			randf_range(0, spawn_offset.y))
	
	_set_obstacle(o, spawn, offset.x if side == 0 else offset.y)
	
	if side == 0:
		o.get_child(0).set_rotation_degrees(180)
		o.get_child(1).set_rotation_degrees(180)


func _set_obstacle(o, spawn_position, offset):
	var final_position = spawn_position.position
	final_position.y += offset
	o.position = final_position
	o.connect("hit", _on_obstacle_hit)
	add_child(o)


# Listeners


func _on_timer_timeout():
	_new_obstacle()


func _on_obstacle_hit(_body):
	collision_entered.emit()
