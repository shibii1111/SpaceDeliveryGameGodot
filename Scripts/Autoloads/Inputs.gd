# Inputs.gd is meant to be a global script that is used for calling things like Pause Menu with Esc key.
# Reason of doing so is to avoid conflicts where for example, the inputs are set on the player and the player is dead.
# It avoids loading an invisible player for the Start Menu.
extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		DevGlobalUtils.ExitGame()
