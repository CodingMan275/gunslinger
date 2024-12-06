extends PanelContainer

@onready var property_container = %VBoxContainer

var moves = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalScript.DebugScript = self
	

func _input(event):
	if(event.is_action_pressed("Debug")):
		visible = !visible
		
		
@rpc("any_peer","call_local")
func add(title : String):
	var property
	property = property_container.find_child(title,true)
	property = Label.new()
	property_container.add_child(property)
	property.text = title 
	moves += title + "\n"

###################################
###################################
###################################
"""
	2. Each one of those nodes, needs to implement the following three functions
   a. get_save_id() : returns a unique id for this node as a string.
	  Apparently, Godot does not have UUIDs, so we have to make our own.
"""
func get_save_id():
	return "debugpanel"

"""
   b. save(): this methods returns a dictionary with the data that node
	  needs to save/restore during gameplay.
	  Here is an example from an unrelated game
"""
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"moves" : moves
	}
	
	return save_dict


"""
	c. restore(saved_data): this method gets a dictionary of previously saved data
	   and uses it to restore the state of the node. This is the same dictonary
	   structure returned by save().
"""
func restore(saved_data):
	moves =saved_data["moves"]
	add(moves)
	pass
