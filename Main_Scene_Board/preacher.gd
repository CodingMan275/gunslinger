extends "res://CPU_and_Player/Character.gd".Character
class_name Preacher

#Get a refrence to the node's parent
@onready var TownieLogic = get_parent()

#@export makes it so the MultiplayerSyncronizor syncs these bools for every peer
#If it was hired that should be known by at least every machine not every player
#IF it was claimed every player should know it
@export var is_hired_gun: bool = false
#@export var claim_revealed: bool = false
@onready var PreacherObj = get_node("../Cards/PreacherCard")
@onready var Rules = get_node("../../Rules_Controller")

#Bool for wheather or not the hired gun can move
#var movable = false

#Which player drew the card
#var Player: int

#Which player owns this hired gun, if any
var OwningPlayer

var KnifeProf = -1
var PistolProf = 1
var RifleProf = -1
var ShotgunProf = 0
var TwinPistolProf = 0
var BrawlProf = 1

func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name = get_name()
	rules = get_parent().get_parent().get_node("Rules_Controller")
	cards = get_parent().get_parent().get_node("Cards")
	#Church
	RandSpawnLoc.append(Vector2(6,0))
	RandSpawnLoc.append(Vector2(7,0))
	#BootHill
	RandSpawnLoc.append(Vector2(6,1))
	RandSpawnLoc.append(Vector2(7,1))
	#Doc Boardwalk
	RandSpawnLoc.append(Vector2(1,3))
	RandSpawnLoc.append(Vector2(1,4))
	pass # Replace with function body.

'''
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#Every frame check to see if this node is movable
	#Was left mouse pressed? Enough Action points?
	if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0:
		#See move_possible, see can_move()
		if move_possible() and can_move(Player):
			#Set node's global position to be the positon of the mouse
			self.global_position = Vector2(get_global_mouse_position())
			#Set pos, a variable for storing location, to be the equivelant tile 
			pos = tile_map_node.local_to_map(self.position)
			#Calls the UpdateMove function with the rpc call
			UpdateMove.rpc(self.global_position)
			#Alright we moved, no more
			movable = false
	elif (Input.is_action_just_pressed("LeftClick") and ActionPoint == 0):
		GlobalScript.DebugScript.add("You have no more Action Points ")

#See rpc exlaination in Townie_Logic
@rpc("any_peer")
#Updates the node's postion for every peer
func UpdateMove(x):
	self.global_position = x
	pos = tile_map_node.local_to_map(self.position)
	pass
'''
#This function is directly connected to the DrawCard signal form the Cards node
#To see its connection click the Cards node on the left and then clicked the "Node"
#tab on the right inspector area
func hire_townsfolk(card, FirstDraw, player):
	#Lets do the hiring process
	hire_rpc.rpc(card,FirstDraw,player)
		
#Theres a way to do this withouth this extra function but its less than 24h
#Future Josh here, I dont care it works, message me for any questions
@rpc("call_local","any_peer")
#Call local makes ONLY the current machine call this function, the opposite of any_peer
func hire_rpc(x,y,z):
	#If this is the starting draw AND this card was draw to be a hired gun
	if(y and (x == "Preacher")):
		#Set owning player equal to the Player_Index + 1 which is equvilent to
		#The correct Player_ID
		owning_player = z + 1
		#I had issues with getting and setting correct owner, this code is outdated
		#but works enough, sorry, any questions message Josh
		OwningPlayer = owning_player
		#Set hired gun bool to true, this var is hooked up to the multiplayer syncronizer
		#plus its rpc'd which means every machine knows this is a hired gun
		is_hired_gun = true
		#PreacherObj.CardPos = Vector2(-37,-78) 
		#Invalid assignment of property or key CardPosition with value type Vector2 on a base object of type Nil WHAT DOES IT MEAN
	pass

#Function that will be called when the claim button is pressed
func reveal_hired_gun() -> void:
	#Set bool of claimed to be true, this bool is apart of the multiplayer syncronizer
	#And so all machines (and ideally all players) know this hired gun is claimed
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
#Check to see if the node can move
func can_move(player) -> bool:
	#Are we set to be movable?
	if movable:
		#Have I been claimed?
		if not claim_revealed:
			print("Not claimed")
			return true
			#Ive been claimed, is the person trying to move me the person who owns me?
		elif is_owning_player(player):
			print("I own it")
			return true
		else:
			#Im claimed and the person trying to move me does not own me
			print("I dont own it")
			return false
	else:
		#Im not movable
		print("Movable false")
		return false
	'''
	

'
#func _on_special_ability_pressed() -> void:
	if Preacher.pos == Rules.Target.pos:
		Rules.Target.pos = Vector2(7,0)
		StunTracker = 3
		GlobalScript.DebugScript.add(str(Rules.Target.Name, " is now pacified"))
		pass # Replace with function body.
'
