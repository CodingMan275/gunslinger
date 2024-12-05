extends Control

@onready var pause_menu_singleplayer = %PauseMenuSingleplayer
@onready var margin_container = %MarginContainer
@onready var margin_container_2 = %MarginContainer2
@onready var pause_menu_options_screen = %PauseMenuOptionsScreen
@onready var close_options_menu_button = %CloseOptionsMenuButton
@onready var RuleController = $"../../../Rules_Controller"
@onready var game_saved_message = %Game_Saved_Message
@onready var game_loading_message = %Game_Loading_Message



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
	game_loading_message.show()
	await get_tree().create_timer(2).timeout
	game_loading_message.hide()
	margin_container.show()
	margin_container_2.hide()
	pause_menu_singleplayer.hide()

func _on_save_button_pressed():
	game_saved_message.show()
	await get_tree().create_timer(2).timeout
	game_saved_message.hide()

func _on_cancel_pressed():
	margin_container.show()
	margin_container_2.hide()
