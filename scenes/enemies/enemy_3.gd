class_name Enemy3
extends Enemy


@export var attack_speed: float = 200


# Godot Messages


func _ready():
	$"Movement System".move_towards(target)


func _process(delta):
	if is_close_to_target():
		$"Movement System".speed = attack_speed
		$"Movement System".set_follow_target(false)
