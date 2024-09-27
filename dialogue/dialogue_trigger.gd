extends Area3D

@export var Dialogue: DialogueResource;

func triggerDialogue(body: Node3D):
	if body.is_in_group("Player"):
		DialogueManager.show_example_dialogue_balloon(Dialogue, "start");
		queue_free();
