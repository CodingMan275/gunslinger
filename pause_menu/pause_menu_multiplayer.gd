extends Control

@onready var pause_menu_multiplayer = %PauseMenuMultiplayer
@onready var margin_container = %MarginContainer
@onready var margin_container_2 = %MarginContainer2
@onready var pause_menu_options_screen = %PauseMenuOptionsScreen
@onready var close_options_menu_button = %CloseOptionsMenuButton




func _on_resume_button_pressed():
	pause_menu_multiplayer.hide()


func _on_options_button_pressed():
	pause_menu_options_screen.show()
	close_options_menu_button.show()


func _on_quit_button_pressed():
	margin_container.hide()
	margin_container_2.show()


func _on_no_button_pressed():
	margin_container.show()
	margin_container_2.hide()


func _on_yes_button_pressed():
	pass
	#get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
