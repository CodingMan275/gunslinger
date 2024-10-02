extends Control


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main_menu/mode_selection_screen.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://main_menu/options_menu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
