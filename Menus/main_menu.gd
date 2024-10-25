extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/level_select.tscn")
