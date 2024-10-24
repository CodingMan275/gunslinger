extends Node

@onready var Preacher = get_node("Preacher")
@onready var Teacher = get_node("Teacher")
@onready var Doctor = get_node("Doctor")
@onready var Town_Drunk = get_node("Town_Drunk")
@onready var Bar_Keep = get_node("Bar_Keep")
@onready var Ranch_Hand = get_node("Ranch_Hand")

@onready var CardDecks = get_node("../Cards")
@onready var Rules = get_node("../Rules_Controller")

var CurrentCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	CardDecks.DrawnCard.connect(UpdateCard)
	
	Preacher.position = get_node("../Layer0").map_to_local(Vector2 (6,6))
	Teacher.position = get_node("../Layer0").map_to_local(Vector2 (6,3))
	Doctor.position = get_node("../Layer0").map_to_local(Vector2 (1,6))
	Town_Drunk.position = get_node("../Layer0").map_to_local(Vector2 (5,4))
	Bar_Keep.position = get_node("../Layer0").map_to_local(Vector2 (7,0))
	Ranch_Hand.position = get_node("../Layer0").map_to_local(Vector2 (6,4))
	
	Preacher.tile_map_node = get_node("../Layer0")
	Teacher.tile_map_node = get_node("../Layer0")
	Doctor.tile_map_node = get_node("../Layer0")
	Town_Drunk.tile_map_node = get_node("../Layer0")
	Bar_Keep.tile_map_node = get_node("../Layer0")
	Ranch_Hand.tile_map_node = get_node("../Layer0")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func UpdateCard(x,y,z):
	if(!y):
		CurrentCard = x
	pass


func _on_claim_pressed() -> void:
	get_node(CurrentCard).reveal_hired_gun()
	get_node(CurrentCard).movable = true
	get_node(CurrentCard).Player = Rules.get_node(str(multiplayer.get_unique_id())).Player_ID
	print(multiplayer.get_unique_id())
	SchizoFunctionPleaseWork.rpc()
	#get_node(CurrentCard).RecievedOwner = Rules.get_node(str(multiplayer.get_unique_id())).Player_ID
	pass # Replace with function body.
	
@rpc("any_peer")
func SchizoFunctionPleaseWork():
	get_node(CurrentCard).reveal_hired_gun()
	get_node(CurrentCard).movable = false
	get_node(CurrentCard).Player = 0
	pass
