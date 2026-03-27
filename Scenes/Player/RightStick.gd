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
	var center := base.position + (base.size / 2.0)
	var direction := local_pos - center

	if direction.length() > radius:
		direction = direction.normalized() * radius

	knob.position = center + direction - (knob.size / 2.0)
	input_vector = direction / radius

func _reset_knob() -> void:
	var center := base.position + (base.size / 2.0)
	knob.position = center - (knob.size / 2.0)
