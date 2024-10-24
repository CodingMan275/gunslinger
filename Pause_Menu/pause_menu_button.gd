extends Button

@onready var pause_menu = %PauseMenu

func _on_pressed():
	pause_menu.show()
