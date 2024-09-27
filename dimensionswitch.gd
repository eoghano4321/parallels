extends Node3D


@onready var oldDimension = $OldDimension;
@onready var newDimension = $NewDimension;
@onready var persistedObjects = $PersistedObjects;
@onready var player = $Player;
@onready var pickups = $Pickups;

@onready var oldCamEnvironment = preload("res://old_environment2.tres");
@onready var newCamEnvironment = preload("res://new_environment.tres");

@export var hintDialogue: DialogueResource;

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
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

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
	DialogueManager.show_example_dialogue_balloon(hintDialogue, "start");
