extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Gets the parent node of its parent node
	var Order = get_parent().get_parent().Player_ID
	text = str("Player ", Order)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var Order = get_parent().get_parent().Player_ID
	text = str("Player ", Order)
	pass
