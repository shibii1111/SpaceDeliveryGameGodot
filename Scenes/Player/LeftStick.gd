extends Control

var is_pressed: bool = false
var input_vector: Vector2 = Vector2.ZERO

@onready var base: TextureRect = $Base
@onready var knob: TextureRect = $Knob

var radius: float = 80.0

func _ready() -> void:
	_reset_knob()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			is_pressed = true
			_update_knob(event.position)
		else:
			is_pressed = false
			input_vector = Vector2.ZERO
			_reset_knob()

	elif event is InputEventScreenDrag and is_pressed:
		_update_knob(event.position)

func _update_knob(local_pos: Vector2) -> void:
	var center: Vector2 = base.position + (base.size / 2.0)
	var direction: Vector2 = local_pos - center

	if direction.length() > radius:
		direction = direction.normalized() * radius

	var raw_input: Vector2 = direction / radius

	if raw_input.length() < 0.2:
		input_vector = Vector2.ZERO
		_reset_knob()
		return

	var angle: float = raw_input.angle()
	var snapped_angle: float = round(angle / (PI / 4.0)) * (PI / 4.0)

	input_vector = Vector2.RIGHT.rotated(snapped_angle)

	var snapped_direction: Vector2 = input_vector * radius
	knob.position = center + snapped_direction - (knob.size / 2.0)

func _reset_knob() -> void:
	var center: Vector2 = base.position + (base.size / 2.0)
	knob.position = center - (knob.size / 2.0)
