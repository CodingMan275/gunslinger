extends Sprite2D




@onready var tile_map_node = get_node("Node2D/Layer0")
var pos : Vector2


var guyyouclicked



func _input(event):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT: #first three lines basically check which sprite you clicked
		var camera = get_viewport().get_camera_2d()
		if get_rect().has_point(to_local(camera.get_global_mouse_position())):
			pos = get_parent().pos # here i have no clue as to how to get the position of the sprite.
			guyyouclicked = self.name
			print("You selected:", guyyouclicked)
			print("Position: ", pos) # it does know which sprite you clicked
			
			
