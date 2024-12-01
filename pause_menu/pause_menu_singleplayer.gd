extends Control

@onready var pause_menu_singleplayer = %PauseMenuSingleplayer
@onready var margin_container = %MarginContainer
@onready var margin_container_2 = %MarginContainer2
@onready var pause_menu_options_screen = %PauseMenuOptionsScreen
@onready var close_options_menu_button = %CloseOptionsMenuButton
@onready var RuleController = $"../../../Rules_Controller"




func _on_resume_button_pressed():
	pause_menu_singleplayer.hide()
	#get_tree().paused = false


func _on_options__button_pressed():
	pause_menu_options_screen.show()
	close_options_menu_button.show()


func _on_save_load_button_pressed():
	margin_container.hide()
	margin_container_2.show()

func _on_quit__button_pressed():
	AudioPlayer.play()
	RuleController.Winner(-1 , false)

func _on_load_button_pressed():
	pass


func _on_save_button_pressed():
	pass


func _on_cancel_pressed():
	margin_container.show()
	margin_container_2.hide()
