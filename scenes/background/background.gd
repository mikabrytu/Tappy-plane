extends ParallaxBackground


@export var speed = 100.0


# Godot Messages


func _process(delta):
	scroll_offset += Vector2.LEFT * speed * delta
