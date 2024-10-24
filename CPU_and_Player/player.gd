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
@export var WeaponDmg = 4
@export var WeaponStun = 1
@export var WeaponRange = 2
@export var StunTracker = 0
@export var FreeBrawl = true;

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

@onready var RangeButton = get_parent().RangeButton
@onready var BrawlButton = get_parent().BrawlButton

@onready var HandButton = get_parent().HandButton

@onready var ClaimButton = get_parent().ClaimButton

@onready var CardNodeDeck = get_parent().CardDecks

@onready var DynamiteButton = get_parent().DynamiteButton


#So the player knows what order it is
var order = 0
#determines whether the player can currently move
@export var can_act = true
#Player hand
#This could be further broken down into Weapon array, Town, Gunslinger, ect
@export var PlayerHand = []

var DrewCard = false

var CurrentCard

#For node path to tile map
var tile_map_node

#Label Name to be used by the PLayer label to keep track of who is who
var LabelName = "TEMP"


var Player = preload("res://CPU_and_Player/PlayerClass.gd").Player.new(0)

#Connect to Rules controller signal when spawned
func _on_ready() -> void:
		#Sets the player instance multiplayer authority to the correct peer
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	#Format Node_Emitter . Signal_From_Emmiter_Node . Connect( Function you want to run in this scene)
	rule_scene.order.connect(_update_turn)
	
	
	CardNodeDeck.DrawEmpty.connect(_resetAP)
	
	CardNodeDeck.DrawnCard.connect(PutCardInHand)
	
	#Gets the current order from the parent scene which is the rules controller
	order = rule_scene.Turn_Order
	
	#Sets the action points the player can use
	action_points = Max_Action_Points
	pass # Replace with function body.

	
		
	

func _update_turn(x):
	#This if statement is probably not needed but it just ensures
	#Only the correct peer will be updated when the signal is recieved
	if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
		#Order is updated from the signal sent by the parent class, rules controller
		#Could be rewritten as order = rules_scene.Turn_Order
		order = x
		#If it is NOT the players turn
		if (Player_ID != order):
			#Hide the end turn button so it can not be used
			EndTurnLabel.hide()
			DrawButton.hide()
			RangeButton.hide()
			BrawlButton.hide()
			HandButton.hide()
			DynamiteButton.hide()
			#Removes the ability for the player to move
			can_act = false
			if(DrewCard):
				get_parent().Townie.get_node(CurrentCard).movable = false
		else:
			#Set action points back to max
			#action_points = Max_Action_Points
			#Allow user to end their turn
			DynamiteButton.show()
			EndTurnLabel.show()
			DrawButton.show()
			RangeButton.show()
			BrawlButton.show()
			HandButton.show()
			can_act = true
			FreeBrawl = true;

#This function is called when the signal from the Cards Node
#is emitted, resets action points when draw deck empty
func _resetAP():
	action_points = Max_Action_Points
	
#When a card is drawn the Cards note emits a signal

func PutCardInHand(Card, FirstDraw, p_i):
	if(!FirstDraw):
		if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
			Claim(Card, Player_ID)
			if(order == Player_ID):
				DrewCard = true
				CurrentCard = Card
				
			#PlayerHand.append(Card)
				can_act = false
			#for cards in PlayerHand.size():
			#	Card == PlayerHand[cards]
				get_parent().Townie.get_node(Card).tile_map_node = tile_map_node	
				get_parent().Townie.get_node(Card).movable = true	
				get_parent().Townie.get_node(CurrentCard).RecievedOwner = Player_ID
				#Put button here for to claim
				DrawButton.hide()
	pass
	
@rpc("call_local","any_peer")
func Claim(x,y):
	CurrentCard = x
	for i in PlayerHand:
		if(PlayerHand.has(CurrentCard)):
			if(!get_parent().Townie.get_node(CurrentCard).claim_revealed):
				get_parent().Townie.get_node(CurrentCard).CurrentOwner = y
				get_parent().Townie.get_node(CurrentCard).RecievedOwner = y
				print("Did we even get here")
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
			if Input.is_action_just_pressed("LeftClick") and can_act and action_points > 0 && GlobalScript.PlayerNode[order-1].StunTracker == 0:
				if  move_possible():
					self.global_position = Vector2(get_global_mouse_position())
					pos = tile_map_node.local_to_map(self.position)
					print(pos)
					action_points -= 1
					DrawButton.hide()
					print("On Boardwalk: " + tile_map_node.is_boardwalk_tile(pos))
					print("On Building: " + tile_map_node.is_building_tile(pos))
					print("On Path: " + tile_map_node.is_path_tile(pos))
			elif (Input.is_action_just_pressed("LeftClick") and move_possible() and action_points == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
		#	if (!can_act):
			#	can_act = true
			elif(Input.is_action_just_pressed("LeftClick") and GlobalScript.PlayerNode[order-1].StunTracker != 0):
				GlobalScript.DebugScript.add("you are stunned and cannot move")
