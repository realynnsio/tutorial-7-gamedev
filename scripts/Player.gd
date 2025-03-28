extends CharacterBody3D

@export var speed: float = 10.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@onready var camera: Camera3D = $Head/Camera3D
var head_position = 0.507
var speed_mult = 1

var camera_x_rotation: float = 0.0
@onready var head: Node3D = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()
	
	# Run, Crouch, Walk
	if Input.is_key_pressed(KEY_SHIFT):
		speed_mult = 4
	elif Input.is_key_pressed(KEY_CTRL):
		speed_mult = 0.3
	else:
		speed_mult = 1
		
	velocity.x = lerp(velocity.x, movement_vector.x * speed_mult * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * speed_mult * speed, acceleration * delta)
	
	# Head position
	if Input.is_key_pressed(KEY_CTRL) && !Input.is_key_pressed(KEY_SHIFT):
		head.position.y = head_position - 0.5
	else:
		head.position.y = head_position
		
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
