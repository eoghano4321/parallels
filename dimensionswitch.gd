extends Node3D


@onready var oldDimension = $OldDimension;
@onready var newDimension = $NewDimension;
@onready var persistedObjects = $PersistedObjects;
@onready var player = $Player;
@onready var pickups = $Pickups;
@onready var pauseMenu = $CanvasLayer/Pause;

@onready var oldCamEnvironment = preload("res://old_environment2.tres");
@onready var newCamEnvironment = preload("res://new_environment.tres");

@export var hintDialogue: DialogueResource;
@export_file var nextLevel: String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.switch_dimension.connect(toggle_dimension);
	if pickups.get_child_count() > 0:
		for child in pickups.get_children():
			child.pickup.connect(toggle_dimension);
	
	newDimension.hide();
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		if pauseMenu.visible == false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pauseMenu.show()
			get_tree().paused = true;
			if get_node("ExampleBalloon"):
				get_node("ExampleBalloon").queue_free()
		else:
			unpause()

func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pauseMenu.hide()
	get_tree().paused = false

func toggle_dimension() -> void:
	if player.get_collision_layer_value(1): # Player is currently in old dimension so switch to new
		player.set_collision_layer_value(1, false)
		player.set_collision_mask_value(1, false)
		player.set_collision_layer_value(2, true)
		player.set_collision_mask_value(2, true)
		newDimension.show();
		oldDimension.hide();
		player.get_node("Head/Camera3D").environment = newCamEnvironment;
	else: # Switch to old
		player.set_collision_layer_value(2, false)
		player.set_collision_mask_value(2, false)
		player.set_collision_layer_value(1, true)
		player.set_collision_mask_value(1, true)
		oldDimension.show();
		newDimension.hide();
		player.get_node("Head/Camera3D").environment = oldCamEnvironment;
	
	for child in persistedObjects.get_children():
		if child.get_child(0).get("visible"):
			child.get_child(0).hide()
			child.get_child(1).show()
		else:
			child.get_child(1).hide()
			child.get_child(0).show()


func _on_timer_timeout() -> void:
	# Give user a hint
	if hintDialogue:
		DialogueManager.show_example_dialogue_balloon(hintDialogue, "start");

func _on_restart_pressed() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene()

func _on_mainmenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/mainMenu.tscn")


func _on_level_end_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Levels.levelsUnlocked += 1
		get_tree().change_scene_to_file(nextLevel)
