extends TileMapLayer

@onready var Sound_Player = %Shuffle_Card
@onready var Sound_Player2 = %Draw_Card
# Called when the node enters the scene tree for the first time.
func _ready():
	fix_invalid_tiles()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_join_pressed():
	Sound_Player.play()
	pass # Replace with function body.


func _on_draw_card_pressed() -> void:
	Sound_Player2.play()
	pass # Replace with function body.


func _on_host_pressed() -> void:
	Sound_Player.play()
	pass # Replace with function body.
