extends PanelContainer

@onready var property_container = %VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalScript.DebugScript = self
	visible = false

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
