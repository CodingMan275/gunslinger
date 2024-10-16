extends Control

@onready var fullscreen_button = %Fullscreen_Button
@onready var check_box = %CheckBox



func _ready():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_button.button_pressed = true
	else:
		fullscreen_button.button_pressed = false
	if AudioServer.is_bus_mute(0) == true:
		check_box.button_pressed = true
	else:
		check_box.button_pressed = false


func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)
	


func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_confirm_changes_button_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db($"TabContainer/Sound/AudioOptions/MarginContainer/VBoxContainer/MasterSlider".value))
	AudioServer.set_bus_volume_db(1, linear_to_db($"TabContainer/Sound/AudioOptions/MarginContainer/VBoxContainer/SFXSlider".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"TabContainer/Sound/AudioOptions/MarginContainer/VBoxContainer/MusicSlider".value))
