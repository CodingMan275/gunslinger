extends TileMapLayer

@onready var Sound_Player2 = $"../CanvasLayer/Draw Card/Draw cards"
@onready var Sound_Player3 = $"../CanvasLayer/Attack/Attack"
@onready var Sound_Player4 = $"../CanvasLayer/Brawl/Punch"

enum TerrainType{
	DIRT_PATH = 1,
	BOARDWALK = 2,
	BUILDING = 3,
	STABLE = 4
}

func _ready():
	fix_invalid_tiles()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_draw_card_pressed() -> void:
	Sound_Player2.play()
	pass # Replace with function body.
	
	
func is_boardwalk_tile(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.BOARDWALK
	
func is_building_tile(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.BUILDING
	
func is_path_tile(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.DIRT_PATH
	
func is_stable_tile(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.STABLE


func _on_attack_pressed() -> void:
	Sound_Player3.play()
	pass # Replace with function body.
	
	

func _on_brawl_pressed() -> void:
	Sound_Player4.play()
	pass # Replace with function body.
