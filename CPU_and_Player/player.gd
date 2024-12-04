extends CharacterBody2D 


#Player ID make exportable so it cna be changed
@export var Player_ID = 1
@export var Max_Action_Points = 2
@export var pos : Vector2
@export var Startpos : Vector2  #Stable position to use dynamite
@export var Health = 20
@export var Name : String
#determines the current number of Action Points
@export var action_points = 0
@export var Weapon1Name = "Filler"
@export var Weapon1Dmg = 4
@export var Weapon1Stun = 1
@export var Weapon1Range = 2
@export var Weapon2Name = "Filler"
@export var Weapon2Dmg = 0
@export var Weapon2Stun = 0
@export var Weapon2Range = 0
@export var StunTracker = 0
@export var Profficenty = 0
@export var FreeBrawl = true

var is_turn = false

#Player is spawned by rules controller as a child of it
#Getting the parent node which has the emitters we need
@onready var rule_scene = get_parent()
#This more specifically gets the tile map which is then used in later
#movement calcs
#@onready var TileMapParent = get_parent().TileMapScene
#Gets the button from the canvas layer where the rules controller is
#This allows for hiding and showing the button unique to each player
@onready var EndTurnLabel = get_parent().EndTurnButton

@onready var DrawButton = get_parent().DrawButton

@onready var AttackButton = get_parent().AttackButton
@onready var AttackUI = get_parent().AttackUI

@onready var HandButton = get_parent().HandButton

@onready var ClaimButton = get_parent().ClaimButton

@onready var CardNodeDeck = get_parent().CardDecks

@onready var DynamiteButton = get_parent().DynamiteButton

@onready var MoveButton = get_parent().MoveButton

@onready var GiveTakeButton = get_parent().GiveTakeButton

@onready var Walk = get_parent()

var KnifeProf = 3
var PistolProf = 3
var RifleProf = 3
var ShotgunProf = 3
var TwinPistolProf = 3
var BrawlProf = 3


#So the player knows what order it is
@export var order = 0
#determines whether the player can currently move
@export var can_act = true
#Player hand
#This could be further broken down into Weapon array, Town, Gunslinger, ect
@export var PlayerHand = []

var MidCard


var DrewCard = false

var CurrentCard

#For node path to tile map
var tile_map_node
var highlight_node
#Movement Button stuff
var Movable = false

#Label Name to be used by the PLayer label to keep track of who is who
var LabelName = "TEMP"

var CanDynamite : bool = true

var Player = preload("res://CPU_and_Player/PlayerClass.gd").Player.new(0)

#Connect to Rules controller signal when spawned
func _on_ready() -> void:
	
	
	#Sets the player instance multiplayer authority to the correct peer
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	#Format Node_Emitter . Signal_From_Emmiter_Node . Connect( Function you want to run in this scene)
	rule_scene.order.connect(_update_turn)
	
	rule_scene.move.connect(_updateMove)
	
	CardNodeDeck.DrawEmpty.connect(_resetAP)
	
	CardNodeDeck.DrawnCard.connect(PutCardInHand)
	
	CardNodeDeck.StartDrawOver.connect(_initialDisplay)
	
	#Gets the current order from the parent scene which is the rules controller
	order = rule_scene.Turn_Order
	
	#Sets the action points the player can use
	action_points = Max_Action_Points
	
	if (self.name == str(multiplayer.get_unique_id()))  || GlobalScript.SinglePlay:
		$CanvasLayer.show()
	pass # Replace with function body.
	#CardSpriteThingy()
	
		

func _updateMove():
	if !DrewCard:
		Movable = true
		if order == Player_ID and is_turn:
			show_possible_moves(pos)
	else:
		get_parent().Townie.get_node(CurrentCard).movable = true
		get_parent().Townie.get_node(CurrentCard).show_possible_moves()
		if get_parent().Townie.get_node(CurrentCard).action_points == 0:
			MoveButton.hide()
	


func _update_turn(x):
	hide_possible_moves()
	#This if statement is probably not needed but it just ensures
	#Only the correct peer will be updated when the signal is recieved
	if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
		#Order is updated from the signal sent by the parent class, rules controller
		#Could be rewritten as order = rules_scene.Turn_Order
		order = x
		#If it is NOT the players turn
		if (Player_ID != order):
			#Hide the end turn button so it can not be used
			is_turn = false
			EndTurnLabel.hide()
			DrawButton.hide()
			rule_scene.PlayerUI(false)
			AttackButton.hide()
			MoveButton.hide()
			GiveTakeButton.hide()
			hide_possible_moves()
		#	HandButton.hide()
			DynamiteButton.hide()
			#Removes the ability for the player to move
			can_act = false
			Movable = false
			#Did I draw a card?
			if(DrewCard):
				#Get the townie I drew and make them unmovable becauseI ended my turn
				get_parent().Townie.get_node(CurrentCard).movable = false
				DrewCard = false
		else:
			#Set action points back to max
			#action_points = Max_Action_Points
			#Allow user to end their turn
			is_turn = true
			EndTurnLabel.show()
			DrawButton.show()
			if action_points != 0:
				DynamiteButton.show()
				AttackButton.show()
				MoveButton.show()
				hide_possible_moves()
			#Did I draw a card?
			if(DrewCard):
				#Get the townie I drew and make them unmovable becauseI ended my turn
				get_parent().Townie.get_node(CurrentCard).movable = false
				DrewCard = false
			NearbyTownieCheck()
	#		HandButton.show()
			can_act = true
			FreeBrawl = true;

#This function is called when the signal from the Cards Node
#is emitted, resets action points when draw deck empty
func _resetAP():
	action_points = Max_Action_Points
	
	
func _initialDisplay():
	$CanvasLayer/Card1.texture = ResourceLoader.load(CardNodeDeck.CardArt(PlayerHand[1]))
	$CanvasLayer/Card2.texture = ResourceLoader.load(CardNodeDeck.CardArt(PlayerHand[2]))
	$CanvasLayer/Card3.texture = ResourceLoader.load(CardNodeDeck.CardArt(PlayerHand[3]))
	MidCard = PlayerHand[1]
	#Put weapons here
	
	pass
	
#When a card is drawn the Cards note emits a signal
func PutCardInHand(Card, FirstDraw, p_i):
	hide_possible_moves()
	#If this is NOT the first draw
	if(!FirstDraw):
		#If I have the authority to access all this
		if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
			#See claim()
			Claim(Card)
			#Is it my turn?
			if(order == Player_ID):
				#Ive drawn a card
				DrewCard = true
				#Set the card I'm looking at to be the card I've drawn
				CurrentCard = Card
				#Remove any other action oppurtunities
				can_act = false
				#Sets the tile_map_node to the proper board refrence
				get_parent().Townie.get_node(Card).tile_map_node = tile_map_node
				#This townie is now movable
				#get_parent().Townie.get_node(Card).movable = true	
				#The current player controlling it is this player
				get_parent().Townie.get_node(CurrentCard).Player = Player_ID
				#Hide the draw button
				DrawButton.hide()
				#MoveButton.hide()
				AttackButton.hide()
				AttackUI.hide()
	pass
	
#This function will run and if the player has the hired gun in their hand
#Then they will get the option to claim it
func Claim(x):
	#Again the card we drew is the car we're looking at
	CurrentCard = x
	#Go through my hand to see if I have this card
	if(PlayerHand.has(CurrentCard)):
		GlobalScript.DebugScript.add(str(self.Name+ " can claim " +CurrentCard))
		#Have I already claimed this card?
		if(!get_parent().Townie.get_node(CurrentCard).claim_revealed):
			#Show the claim button
			ClaimButton.show()
	pass

	#Movement
func _physics_process(delta):
	MoveMouse()
	
	
	
func move_possible():
	#print(tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())))
	return tile_map_node.local_to_map(Vector2(get_global_mouse_position())) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) #and tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())) != -1

func MoveMouse():
	#Another if statement that is probably not needed but ensures that only the peer
	#who owns this player instance can move it
	
	if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
		if(Player_ID == order):
			if Movable:
				if Input.is_action_just_pressed("LeftClick") and can_act and action_points > 0 && GlobalScript.PlayerNode[order-1].StunTracker == 0:
					var NewPos = tile_map_node.local_to_map(Vector2(get_global_mouse_position()))
					print(NewPos)
					if  move_possible():
						if TileCheck(NewPos):
							Walk.playWalk()
							self.global_position = Vector2(get_global_mouse_position())
							pos = NewPos
							action_points -= 1
							if action_points == 0:
								MoveButton.hide()
							GlobalScript.DebugScript.add(str(self.Name)+" has "+str(self.action_points) + " action points left ")
							DrawButton.hide()
							Movable = false
							UpdateMove.rpc(self.global_position, NewPos)
							NearbyTownieCheck()
							hide_possible_moves()
						elif !TileCheck(NewPos):
							GlobalScript.DebugScript.add("You Can not move into a wall ")
							hide_possible_moves()
				elif (Input.is_action_just_pressed("LeftClick") and move_possible() and action_points == 0):
					GlobalScript.DebugScript.add("You have no more Action Points ")
					hide_possible_moves()
				elif(Input.is_action_just_pressed("LeftClick") and GlobalScript.PlayerNode[order-1].StunTracker != 0):
					GlobalScript.DebugScript.add("you are stunned and cannot move")
					hide_possible_moves()
@rpc("any_peer")
func UpdateMove(x, NewPos):
	self.global_position = x
	pos = NewPos
	
func show_possible_moves(pos):
	for tile in tile_map_node.get_surrounding_cells(pos):
		if TileCheck(tile):
			highlight_node.set_cell(tile, 16, Vector2i(0,0))
	
func hide_possible_moves():
	highlight_node.clear()

func NearbyTownieCheck():
	#Checks if a hired gun is on the same sqaure as you or surrounding
	if order == Player_ID:
		if (get_parent().Townie.get_node(PlayerHand[1]).pos == pos || get_parent().Townie.get_node(PlayerHand[2]).pos == pos || get_parent().Townie.get_node(PlayerHand[3]).pos == pos || 
		tile_map_node.local_to_map(Vector2(get_parent().Townie.get_node(PlayerHand[1]).position)) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) || tile_map_node.local_to_map(Vector2(get_parent().Townie.get_node(PlayerHand[2]).position)) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) || tile_map_node.local_to_map(Vector2(get_parent().Townie.get_node(PlayerHand[3]).position)) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position))):
	#Checks if they have been reavled
			if get_parent().Townie.get_node(PlayerHand[1]).claim_revealed || get_parent().Townie.get_node(PlayerHand[2]).claim_revealed || get_parent().Townie.get_node(PlayerHand[3]).claim_revealed:
				GiveTakeButton.show()
	else:
		GiveTakeButton.hide()
	pass

func TileCheck(pos) -> bool:
	var Ppos = GlobalScript.PlayerNode[order-1].pos
	#Cannot move to a null space
	if tile_map_node.get_cell_atlas_coords(pos) == Vector2i(-1, -1):
			return false
	#Cannot move into stable , Bank , Church , School from a path
	elif tile_map_node.Path(Ppos) && (tile_map_node.Stable(pos) || tile_map_node.WalledBuilding(pos)) :
		return false
	#Cannot move from a special building to a path
	elif tile_map_node.WalledBuilding(Ppos) && tile_map_node.Path(pos):
		return false
	#Can only go from jail to sherrif
	elif tile_map_node.Jail(Ppos) && !tile_map_node.Building(pos):
		return false
	#Can not move to jail
	elif tile_map_node.Jail(pos):
		return false
	else:
		return true
	return true
