extends TileMap


var GridSize = 16
var Dict = {}
var selectedTile

#Variables for world turn order
var Turn_Order = 1
#Creating a custom signal which will emit when turn order changes
#Can be emited on _ready to make sure all players are updated
signal Order

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
	#	print(Dict[str(tile)])

#When the button in the canvas layer is pressed this function goes
func _on_button_pressed() -> void:
	#Turn order updated
	Turn_Order = Turn_Order + 1
	#Max two players for this test
	if Turn_Order == 3:
		Turn_Order = 1
	#Check
	print(Turn_Order)
	#Signal is emitted with the information of turn order
	Order.emit(Turn_Order)
	pass # Replace with function body.
