extends Control


@export var character_limit: int = 10


# Godot Messages


func _input(event):
	if Input.is_action_just_pressed("Backspace") and not $TextEdit.editable:
		$TextEdit.editable = true


# Listeners


func _on_text_edit_text_changed():
	if $TextEdit.text.length() >= character_limit:
		$TextEdit.editable = false
