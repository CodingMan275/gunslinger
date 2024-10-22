extends TileMapLayer

@onready var Sound_Player = $"../CanvasLayer/Draw Card/Draw cards"
func _ready():
	fix_invalid_tiles()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_draw_card_pressed() -> void:
	Sound_Player.play()
	
