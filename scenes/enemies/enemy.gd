class_name Enemy
extends Area2D


@export_category("Bullet")
@export var bullet_scene: PackedScene
@export var bullet_spawn: Marker2D

var target: Node2D
var origin: Vector2
var can_shoot: bool = true
var is_exploding: bool = false


# Public API


func set_target(target):
	if target == null:
		return
	
	self.target = target


func set_origin(origin):
	self.origin = origin
	position = origin


func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	
	var b = bullet_scene.instantiate()
	get_tree().root.add_child.call_deferred(b)
	b.setup(bullet_spawn, Vector2.LEFT, collision_layer)


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var layer = body.collision_layer
	var score = 0
	
	if layer == 1:
		score = 3
	elif layer == 5:
		score = 1
	
	GameManager.increase_score(score)
	$AnimatedSprite2D.play("explosion")
	is_exploding = true
	
	await get_tree().create_timer(0.5).timeout
	
	queue_free()