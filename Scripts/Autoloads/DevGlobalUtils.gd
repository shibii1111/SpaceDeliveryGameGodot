# That script is meant for dev purpose.
# It will be a quick way to add things to test, debug, exit game, etc. 

extends Node

func ExitGame() -> void:
	get_tree().quit()
