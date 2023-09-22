extends Area2D


var _parent_layer = -1


# Public API


func setup(spawn, direction, layer):
	global_position = spawn.global_position
	$"Movement System".direction = direction
	$Sprite2D.rotation_degrees = 90 * direction.x
	_parent_layer = layer


# Listeners


func _on_body_entered(body):
	var layer = body.collision_layer
	if layer == _parent_layer:
		return
	
	if (layer == 1):
		var player = body as Player
		player.try_kill()
	
	queue_free()
