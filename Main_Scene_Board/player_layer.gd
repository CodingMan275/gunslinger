extends TileMapLayer

enum TerrainType{
	
	# 7 BUILDING
	STORE = 1,
	CHURCH= 2,
	DOCTOR = 3,
	BANK = 4,
	SHERRIF = 5,
	SCHOOL = 6,
	SALOON = 7,
	# 3 Extras
	JAIL = 8,
	PATH = 9,
	STABLE = 10,
	# 6 BaordWalks
	STOREB = 11,
	BOOTHILL = 12,
	DOCTORB = 13,
	BANKB = 14,
	SHERRIFB = 15,
	YARD = 16
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

func SameBuilding(Player : Vector2 , Enemy : Vector2) -> bool:
	#If you both are on the same type of enum building
	if get_cell_tile_data(Player).get_custom_data("TileType") == get_cell_tile_data(Enemy).get_custom_data("TileType"):
		return true
	# You are on the boardwalk connected to the building
	elif get_cell_tile_data(Player).get_custom_data("TileType") - 10 == get_cell_tile_data(Enemy).get_custom_data("TileType"):
		return true
	else:
		return false

func Boardwalk(location : Vector2) -> bool:
	var ENUM = get_cell_tile_data(location).get_custom_data("TileType")
	return ENUM > 10

func Building(location : Vector2) -> bool:
	var ENUM = get_cell_tile_data(location).get_custom_data("TileType")
	return ENUM < 8

func WalledBuilding(location : Vector2) -> bool:
	var ENUM = get_cell_tile_data(location).get_custom_data("TileType")
	return (ENUM < 8 && ENUM %2 == 0)

func Path(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.PATH
	
func Stable(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.STABLE

func Jail(location : Vector2) -> bool:
	return get_cell_tile_data(location).get_custom_data("TileType") == TerrainType.JAIL
