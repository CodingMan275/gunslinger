extends Label

var Order = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Sets the label as Player 1's Turn
	text = str("Player ", Order, "'s Turn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#When turn end button pressed
func _on_button_pressed() -> void:
	#Incremements Turn Order
	Order = Order + 1
	if Order == 3:
		Order =1
		#Player 2's Turn and it spaws between that and Player 1's
	text = str("Player ", Order, "'s Turn")
	
	pass # Replace with function body.
