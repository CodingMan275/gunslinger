extends Control

@onready var pause_menu_singleplayer = %PauseMenuSingleplayer
@onready var margin_container = %MarginContainer
@onready var margin_container_2 = %MarginContainer2
@onready var options_menu = %OptionsMenu
@onready var close_options_menu_button = %CloseOptionsMenuButton




func _on_resume_button_pressed():
	pause_menu_singleplayer.hide()
	#get_tree().paused = false


func _on_options__button_pressed():
	options_menu.show()
	close_options_menu_button.show()


func _on_quit__button_pressed():
	margin_container.hide()
	margin_container_2.show()


func _on_no_button_pressed():
	margin_container.show()
	margin_container_2.hide()


func _on_yes_button_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
