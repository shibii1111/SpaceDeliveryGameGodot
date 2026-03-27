extends CharacterBody2D

@export var move_speed: float = 500.0
@export var friction: float = 100.0

@onready var mobile_control := $"../MobileControl"
@onready var left_stick := mobile_control.get_node("LeftStick")
@onready var right_stick := mobile_control.get_node("RightStick")

var external_move_dir: Vector2 = Vector2.ZERO
var external_aim_dir: Vector2 = Vector2.ZERO
var use_external_input: bool = false

func _physics_process(delta: float) -> void:
	var move_dir := _get_move_dir()
	var aim_dir := _get_aim_dir(move_dir)

	velocity = move_dir * move_speed
	move_and_slide()

	if aim_dir != Vector2.ZERO:
		rotation = aim_dir.angle()

func _get_move_dir() -> Vector2:
	if mobile_control != null:
		var stick_dir: Vector2 = left_stick.input_vector
		if stick_dir != Vector2.ZERO:
			return stick_dir.normalized()

	if use_external_input:
		return external_move_dir.normalized()

	return Input.get_vector("left", "right", "up", "down")

func _get_aim_dir(move_dir: Vector2) -> Vector2:
	if mobile_control != null:
		var stick_dir: Vector2 = right_stick.input_vector
		if stick_dir != Vector2.ZERO:
			return stick_dir.normalized()
		elif move_dir != Vector2.ZERO:
			return move_dir.normalized()
		else:
			return Vector2.ZERO

	if use_external_input:
		if external_aim_dir != Vector2.ZERO:
			return external_aim_dir.normalized()
		elif move_dir != Vector2.ZERO:
			return move_dir.normalized()
		else:
			return Vector2.ZERO

	if Input.is_action_pressed("fire"):
		return global_position.direction_to(get_global_mouse_position())
	elif move_dir != Vector2.ZERO:
		return move_dir.normalized()

	return Vector2.ZERO
