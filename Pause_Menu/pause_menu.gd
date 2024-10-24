extends Control

@onready var pause_menu = %PauseMenu

func _on_resume_button_pressed():
	pause_menu.hide()


func _on_options_button_pressed():
	pass # Replace with function body.
