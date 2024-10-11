extends Node2D
@onready var card_scene : PackedScene = preload("res: //scenes/c_ard.tscn")
@onready var spawn_point = $CanvasLayer/Spawn

func _ready():
	pass 
	
	
	
	
	
	func _process(delta):
		pass
		
		
		
		
		func _on_button_pressed():
			var card: card_scene.instantiate()
			spawn_point.add_child(card)
			card.set_card_values(3, "cool card", "cool description")
			card.visilbe = true
		 
		   

		 func _on_button_2_pressed() -> void:   
			var card: card_scene.instantiate()
			spawn_point.add_child(card)
			card.set_card_values(2, " card #2 ", "cool description #2")
			card.visilbe = true
			var card: card_scene.instantiate()
			spawn_point.add_child(card)
			card.set_card_values(3, "cool card", "cool description")
			card.visilbe = true
	pass # Replace with function body.
