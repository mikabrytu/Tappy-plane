class_name Move
extends Node


@export var speed: float
@export var direction: Vector2
@export var move: bool


# Godot Messages


func _process(delta):
	if move:
		get_parent().position += direction * speed * delta


# Public API


func can_move(m: bool):
	move = m
