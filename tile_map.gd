extends TileMap


var GridSize = 16
var Dict = {}
var selectedTile

func _ready():
	for x in GridSize:
		for y in GridSize:
			Dict[str(Vector2(x, y))] = {
				"Type": "Grass",
				"Position" : str(Vector2(x, y))
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0, 0), 0)
	#print(Dict)
	
func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
	selectedTile = map_to_local(tile)
	
	for x in GridSize:
		for y in GridSize:
			erase_cell(1, Vector2(x, y))
	
	if Dict.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0,0), 0)
		print(Dict[str(tile)])
