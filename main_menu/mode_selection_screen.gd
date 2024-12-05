extends Control

@onready var single_player_warning_message = %"Single-Player_Warning_Message"
@onready var save_overwriting_message = %Save_Overwriting_Message


func _on_local_button_pressed():
	GlobalScript.SinglePlay = true
	get_tree().change_scene_to_file("res://Main_Scene_Board/node_2d.tscn")
	AudioPlayer.stop()
	#single_player_warning_message.show()

func _on_online_button_pressed():
	AudioPlayer.stop()
	GlobalScript.SinglePlay = false
	get_tree().change_scene_to_file("res://Josh_Test_Scenes/world.tscn")


func _on_continue_button_pressed():
	#Just for testing the buttons in the single_player_warning_message
	single_player_warning_message.show()


func _on_yes_button_pressed():
	save_overwriting_message.show()
	await get_tree().create_timer(2).timeout
	save_overwriting_message.hide()
	GlobalScript.SinglePlay = true
	get_tree().change_scene_to_file("res://Main_Scene_Board/node_2d.tscn")


func _on_no_button_pressed():
	single_player_warning_message.hide()
