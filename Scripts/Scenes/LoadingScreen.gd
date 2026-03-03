extends CanvasLayer

signal loading_screen_ready

@export var animation_player: AnimationPlayer
@export var percent_text: TextEdit

func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(percent: float) -> void:
	print(percent)
	percent_text.text = "loading... " + str(int(percent)) + "%"
		
func _on_load_finished() -> void:
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	queue_free()
