extends "res://CPU_and_Player/Character.gd".Character
class_name Ranch_Hand

@onready var TownieLogic = get_parent()


@export var is_hired_gun: bool = false
#@export var claim_revealed: bool = false

#@export var MultiplayerAuthority: int

#var movable = false

#@export var Player: int

var OwningPlayer

var KnifeProf = 0
var PistolProf = 0
var RifleProf = 0
var ShotgunProf = 0
var TwinPistolProf = 0
var BrawlProf = 0

func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name = get_name()
	get_node("../../Cards").DrawnCard.connect(hire_townsfolk)
	rules = get_parent().get_parent().get_node("Rules_Controller")
	cards = get_parent().get_parent().get_node("Cards")
	pass # Replace with function body.

'''
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Move: "+str(move_possible()))
	#print(ActionPoint)
		if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0 and movable:
			if move_possible() and can_move(Player):
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
	pos = tile_map_node.local_to_map(self.position)
	pass
'''

func hire_townsfolk(card, FirstDraw, player):
	hire_rpc.rpc(card,FirstDraw,player)
		
#Theres a way to do this withouth this extra function but its less than 24h
@rpc("call_local","any_peer")
func hire_rpc(x,y,z):
	if(y and (x == "Ranch_Hand")):
		owning_player = z + 1
		OwningPlayer = owning_player
		is_hired_gun = true
		print("Hired P")
	pass

func reveal_hired_gun() -> void:
	reveal_rpc.rpc()

@rpc("call_local","any_peer")
func reveal_rpc():
	claim_revealed = true
	pass


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
	if movable:
		if not claim_revealed:
			print("Not claimed")
			return true
		elif is_owning_player(player):
			print("I own it")
			return true
		else:
			print("I dont own it")
			return false
	else:
		print("Movable false")
		return false

'''
