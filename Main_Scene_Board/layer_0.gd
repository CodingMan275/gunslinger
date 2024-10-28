extends TileMapLayer

@onready var Sound_Player2 = $"../CanvasLayer/Draw Card/Draw cards"
@onready var Sound_Player3 = $"../CanvasLayer/Attack/Attack"
@onready var Sound_Player4 = $"../CanvasLayer/Brawl/Punch"

enum TerrainType{
	PATH = 1,
	BOARDWALK = 2,
	BUILDING = 3,
	STABLE = 4
}

func _ready():
	fix_invalid_tiles()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Code to check the ENUM of a tile
	"""
	if Input.is_action_just_pressed("LeftClick"):
		var location = get_node("../Layer0").local_to_map(Vector2(get_global_mouse_position()))
		print(get_cell_tile_data(location).get_custom_data("TileType"))
	"""
		
	pass


func Boardwalk(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.BOARDWALK
	
func Building(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.BUILDING
	
func Path(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.PATH
	
func Stable(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.STABLE




func _on_draw_card_pressed() -> void:
	Sound_Player2.play()
	pass # Replace with function body.

func _on_attack_pressed() -> void:
	Sound_Player3.play()
	pass # Replace with function body.

func _on_brawl_pressed() -> void:
	Sound_Player4.play()
	pass # Replace with function body.
