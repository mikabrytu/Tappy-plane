class_name Move
extends Node


@export var speed: float
@export var direction: Vector2
@export var move: bool

var _final_direction: Vector2
var _target: Node2D
var _follow_target: bool


# Godot Messages


func _ready():
	_final_direction = direction


func _process(delta):
	if move:
		if _target != null and _follow_target and _target.position != Vector2.ZERO:
			_final_direction = get_parent().position.direction_to(_target.position)
		
		get_parent().position += _final_direction * speed * delta


# Public API


func move_towards(target: Node2D):
	set_follow_target(true)
	_target = target


func can_move(m: bool):
	move = m


func set_follow_target(follow):
	_follow_target = follow
