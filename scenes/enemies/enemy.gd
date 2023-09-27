class_name Enemy
extends Area2D

@export var score: int
@export_category("Target")
@export var distance: float
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


func is_close_to_target() -> bool:
	if target == null:
		return false
	
	return (global_position.x - target.global_position.x) < distance


# Listeners


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var layer = body.collision_layer
	
	GameManager.increase_score(score if layer == 1 else 1)
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.play("explosion")
	$CollisionShape2D.set_deferred("disabled", true)
	is_exploding = true
	
	if layer == 1:
		$"Floating Score".play(score)
	
	var player = body as Player
	if player != null:
		player.try_kill()
	
	await get_tree().create_timer(0.5).timeout
	
	queue_free()
