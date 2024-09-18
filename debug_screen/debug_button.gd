extends Button

var level_path  := "" :
	set = _set_level_path

func _set_level_path(value):
	level_path = value

func _on_button_up():
	get_tree().change_scene_to_file(level_path)
