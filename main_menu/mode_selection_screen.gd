extends Control



func _on_local_button_pressed():
	GlobalScript.SinglePlay = true
	get_tree().change_scene_to_file("res://Main_Scene_Board/node_2d.tscn")
	AudioPlayer.stop()


func _on_online_button_pressed():
	AudioPlayer.stop()
	GlobalScript.SinglePlay = false
	get_tree().change_scene_to_file("res://Josh_Test_Scenes/world.tscn")


func _on_continue_button_pressed():
	pass # Replace with function body.
