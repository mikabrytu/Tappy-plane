class_name Move
extends Node


@export var speed: float
@export var direction: Vector2
@export var autostart: bool


# Godot Messages


func _process(delta):
	if autostart:
		get_parent().position += direction * speed * delta
