extends Sprite2D

signal gotit



@onready var tile_map_node = get_node("Node2D/Player_Layer")
@onready var rules = get_node("../../../Rules_Controller")
var pos : Vector2
var guyyouclicked




func _input(event):
	#first three lines basically check which sprite you clicked
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT: 
		var camera = get_viewport().get_camera_2d()
		if get_rect().has_point(to_local(camera.get_global_mouse_position())):
			guyyouclicked = get_parent().name
			print("You selected:", guyyouclicked)
			rules.SelectTownie.rpc(guyyouclicked)
