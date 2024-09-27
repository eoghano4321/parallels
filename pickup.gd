extends Node3D

signal pickup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		pickup.emit()
		if self.get_child_count() > 0:
			for child in self.get_children():
				if child.is_in_group("dialogue"):
					child.triggerDialogue(body)
		queue_free()
