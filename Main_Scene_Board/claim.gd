extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	DoneClaiming.rpc()
	pass # Replace with function body.
	
@rpc("call_local","any_peer")
func DoneClaiming():
	self.hide()
	pass


func _on_button_pressed() -> void:
	DoneClaiming.rpc()
	pass # Replace with function body.
