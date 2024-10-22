extends "res://CPU_and_Player/Character.gd".Character
class_name Preacher

@onready var TownieLogic = get_parent()


@export var is_hired_gun: bool = false
@export var claim_revealed: bool = false

#@export var MultiplayerAuthority: int

var movable = false


func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move()
	pass
	
		#takes the player attempting to make the move for reasons that are applicable in later child classes
func move():
	#print("Move: "+str(move_possible()))
	#print(ActionPoint)

	if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0 and movable:
		if move_possible():
			self.global_position = Vector2(get_global_mouse_position())
			pos = tile_map_node.local_to_map(self.position)
			UpdateMove.rpc(self.global_position)
			print(pos)
			movable = false
		#DrawButton.hide()
	elif (Input.is_action_just_pressed("LeftClick") and ActionPoint == 0):
		GlobalScript.DebugScript.add("You have no more Action Points ")

@rpc("any_peer")
func UpdateMove(x):
	self.global_position = x
	pass

func hire_townsfolk(card, FirstDraw, player):
	if(FirstDraw and (card == "Preacher")):
		owning_player = player
		is_hired_gun = true
		print("Hired")

func reveal_hired_gun() -> void:
	claim_revealed = true
	print("claimed")

func can_shoot(player) -> bool:
	if claim_revealed and is_owning_player(player) and has_gun and not get_is_stunned():
		return true
	return false
				
func can_brawl(player) -> bool:
	if claim_revealed and is_owning_player(player) and not get_is_stunned():
		return true
	return false
	
'''
func can_move(player) -> bool:
	if not claim_revealed:
		return true
	elif is_owning_player(player):
		return true
	else:
		'return false
	'''
	
