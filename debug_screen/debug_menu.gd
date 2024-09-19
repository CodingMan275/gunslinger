extends Control

@export_file("*.tscn") var scenes : Array[String]
@onready var v_box_container = %VBoxContainer
@onready var button_class = preload("res://debug_screen/debug_button.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	if scenes == null or scenes.size() == 0:
		print("Drag *.tscn level names from res:// to Scenes (debug_menu.gd) array in Inspector")
	else:
		for s in scenes:
			var level_name = s.get_file().get_basename()
			var level_path = s
			var b = button_class.instantiate() 
			b.text = level_name
			b.level_path = level_path
			v_box_container.add_child(b)
			print(b.text)			


func _on_exit_pressed():
	get_tree().quit()
	#print("Exit Pressed")
