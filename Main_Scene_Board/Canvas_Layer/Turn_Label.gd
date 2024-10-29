extends Label

var Order = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Sets the label as Player 1's Turn
	get_node("../../Rules_Controller").order.connect(update_label)
	text = str("Player 1's Turn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_label(x):
	text = str("Player ", x, "'s Turn")
	# Trying to get this to work
	#text = str(GlobalScript.PlayerNode[x-1].Name,"'s Turn")
