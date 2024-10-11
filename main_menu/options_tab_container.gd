extends Control



func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)


func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)
	



func _on_1280_x_720_resolution_button_pressed():
	DisplayServer.window_set_size(Vector2i(1280,720))


func _on_1920_x_1080_resolution_button_2_pressed():
	DisplayServer.window_set_size(Vector2i(1920,1080))
