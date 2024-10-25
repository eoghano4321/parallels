extends CharacterBody3D

signal switch_dimension


const SPEED = 5.0
const JUMP_VELOCITY = 5.8
@export var mouse_sensitivity=0.2
var rotation_target: Vector3
var coyote = true;
@onready var head = $Head;

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if $Coyote.is_stopped():
			$Coyote.start()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() || coyote):
		velocity.y = JUMP_VELOCITY
		coyote = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Mouse movement

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y*mouse_sensitivity))
		head.rotation.x=clamp(head.rotation.x,-0.9,0.9)


func _on_coyote_timeout() -> void:
	coyote = false;
