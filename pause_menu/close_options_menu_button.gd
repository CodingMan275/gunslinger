extends Button

@onready var options_menu = %OptionsMenu
@onready var close_options_menu_button = %CloseOptionsMenuButton

func _on_pressed():
	options_menu.hide()
	close_options_menu_button.hide()
