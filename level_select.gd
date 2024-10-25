extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	while i <= Levels.levelsUnlocked && i < $GridContainer.get_child_count():
		$GridContainer.get_child(i).disabled = false
		i += 1


func _on_button_pressed(extra_arg_0: String) -> void:
	get_tree().change_scene_to_file(extra_arg_0)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/mainMenu.tscn")
