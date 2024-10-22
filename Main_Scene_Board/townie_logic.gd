extends Node

@onready var Preacher = get_node("Preacher")

@onready var CardDecks = get_node("../Cards")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Preacher.position = get_node("../Layer0").map_to_local(Vector2 (6,6))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
