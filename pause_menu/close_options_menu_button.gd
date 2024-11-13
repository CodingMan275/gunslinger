extends Button

@onready var pause_menu_options_screen = %PauseMenuOptionsScreen
@onready var close_options_menu_button = %CloseOptionsMenuButton

func _on_pressed():
	pause_menu_options_screen.hide()
	close_options_menu_button.hide()
