extends CharacterBody2D 


#Player ID make exportable so it cna be changed
@export var Player_ID = 1
@export var Max_Action_Points = 2
@export var pos : Vector2
@export var Startpos : Vector2  #Stable position to use dynamite
@export var TargetStable: Vector2
@export var Health = 20
@export var Name : String
#determines the current number of Action Points
@export var action_points = 0
@export var Weapon1Name = ""
@export var Weapon1Dmg = 4
@export var Weapon1Stun = 1
@export var Weapon1Range = 2
@export var Weapon2Name = ""
@export var Weapon2Dmg = 4
@export var Weapon2Stun = 1
@export var Weapon2Range = 2
@export var StunTracker = 0
@export var Profficenty = 0
@export var FreeBrawl = true
@export var lostTownie : bool = false

var KnifeProf = 0
var PistolProf = 0
var RifleProf = 0
var ShotgunProf = 0
var TwinPistolProf = 0
var BrawlProf = 0

#Player is spawned by rules controller as a child of it
#Getting the parent node which has the emitters we need
@onready var rule_scene = get_parent()
#This more specifically gets the tile map which is then used in later
#movement calcs
#@onready var TileMapParent = get_parent().TileMapScene
#Gets the button from the canvas layer where the rules controller is
#This allows for hiding and showing the button unique to each player
@onready var EndTurnLabel = get_parent().EndTurnButton
@onready var MoveButton = get_parent().MoveButton

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

var CanDynamite : bool = true


#new Junk
@onready var GiveTakeButton = get_parent().GiveTakeButton
@onready var Walk = get_parent()
var Movable = false
var highlight_node


#Connect to Rules controller signal when spawned
func _on_ready() -> void:
	#Format Node_Emitter . Signal_From_Emmiter_Node . Connect( Function you want to run in this scene)
	rule_scene.order.connect(_update_turn)
	CardNodeDeck.DrawEmpty.connect(_resetAP)
	CardNodeDeck.DrawnCard.connect(PutCardInHand)
	CardNodeDeck.DrawEmpty.connect(_resetAP)
	CardNodeDeck.DrawnCard.connect(PutCardInHand)
	
	#Sets the player instance multiplayer authority to the correct peer
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
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
			can_act = false
			if(DrewCard):
				get_parent().Townie.get_node(CurrentCard).movable = false
				DrewCard = false
		else:
			can_act = true
			FreeBrawl = true
			StartTurn()



func StartTurn():
	await get_tree().create_timer(1).timeout
	if(!rule_scene.Dynamite()):
		var option = randi()%100+1
		print(option)
		if option <= 50 || action_points == 0 || StunTracker > 0:
			DrawPhase()
		elif option > 50 && action_points > 0 && StunTracker == 0:
			if(await ActionPhase(option) && get_tree() != null):
				await get_tree().create_timer(1).timeout
				rule_scene._on_button_pressed()



func DrawPhase():
	lostTownie = false
	CardNodeDeck._onCardDraw()
	#after this we need some sort of check to see if someone claimed the townie
	await get_tree().create_timer(3).timeout
	
	#This would do townie control then stope
	if(!lostTownie):
		rule_scene._on_button_pressed()
	else:
		EndTurnLabel.show()
		MoveButton.show()

func ActionPhase(option) -> bool:
	if option <= 75:
		MoveCPU()
	else:
		rule_scene.Target = GlobalScript.PlayerNode[0]
		rule_scene.TargetGunSlinger = true
		if(!rule_scene.BrawlAttack("Player")):
			if(!rule_scene.RangeAttack("Player")):
				var pick = randi()%1 +1
				if pick == 1 && action_points > 0:
					MoveCPU()
				else:
					DrawPhase()
	await get_tree().create_timer(1).timeout
	return !rule_scene.Dynamite()




#This function is called when the signal from the Cards Node
#is emitted, resets action points when draw deck empty
func _resetAP():
	action_points = Max_Action_Points

func TileCheck(pos) -> bool:
	var Ppos = GlobalScript.PlayerNode[1].pos
	#Cannot move into stable , Bank , Church , School from a path
	if tile_map_node.Path(Ppos) && (tile_map_node.Stable(pos) || tile_map_node.WalledBuilding(pos)) :
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



#When a card is drawn the Cards note emits a signal
func PutCardInHand(Card, FirstDraw, p_i):
	if(!FirstDraw):
		if ($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() || GlobalScript.SinglePlay):
			Claim(Card)
			if(order == Player_ID):
				DrewCard = true
				CurrentCard = Card
				can_act = false
			#for cards in PlayerHand.size():
			#	Card == PlayerHand[cards]
				get_parent().Townie.get_node(Card).tile_map_node = tile_map_node
				get_parent().Townie.get_node(CurrentCard).Player = Player_ID
				get_parent().Townie.get_node(Card).movable = true
				#Put button here for to claim
				DrawButton.hide()
	pass


#This function will run and if the player has the hired gun in their hand
#Then they will get the option to claim it
func Claim(x):
	#Again the card we drew is the car we're looking at
	CurrentCard = x
	#Go through my hand to see if I have this card
	if(PlayerHand.has(CurrentCard)):
		#GlobalScript.DebugScript.add(str(self.Name+ " Has claimed " +CurrentCard))
		'''MICHAEL LOOK RIGHT HERE'''
		#INPUT CODE RIGHT HERE FOR THE CPU TO CLAIM THE TOWNIE
		#AND ALSO SET TOWNIE TO MOVEABLE = FALSE
		#Have I already claimed this card?
		if(!get_parent().Townie.get_node(CurrentCard).claim_revealed):
			print("Card Belongs to CPU")
			#Show the claim button
	pass

func move_possible():
	#show_possible_moves(pos)
	var option = randi()%3+1
	await get_tree().create_timer(1).timeout
	if option == 1 || pos == Startpos:
		if pos.x < TargetStable.x && TileCheck(Vector2(pos.x+1,pos.y)):
			pos.x += 1
		elif pos.y < TargetStable.y && TileCheck(Vector2(pos.x,pos.y+1)):
			pos.y += 1
		elif pos.x > TargetStable.x && TileCheck(Vector2(pos.x-1,pos.y)):
			pos.x -= 1
		elif pos.y > TargetStable.y && TileCheck(Vector2(pos.x,pos.y-1)):
			pos.y -= 1
	else:
		var picked = false
		while !picked:
			var randpick = randi()%4 + 1
			if  randpick == 1 && pos.x !=7:
				if TileCheck(Vector2(pos.x+1,pos.y)):
					pos.x += 1
					picked = true
			if randpick == 2 && pos.y != 7:
				if randpick == 2 && TileCheck(Vector2(pos.x,pos.y+1)):
					pos.y += 1
					picked = true
			if randpick == 3 && pos.x !=0:
				if randpick == 3 && TileCheck(Vector2(pos.x-1,pos.y)):
					pos.x -= 1
					picked = true
			if randpick == 4 && pos.y !=0:
				if TileCheck(Vector2(pos.x,pos.y-1)):
					pos.y -= 1
					picked = true
	Walk.playWalk()
	rule_scene.TileMapScene.map_to_local(Vector2(pos.x,pos.y))
	self.global_position = rule_scene.TileMapScene.map_to_local(pos)
	action_points -= 1
	GlobalScript.DebugScript.add("CPU has "+str(self.action_points) + " action points left ")
	Movable = false
	hide_possible_moves()

func MoveCPU():
	if  GlobalScript.PlayerNode[order-1].StunTracker == 0:
		move_possible()
		await get_tree().create_timer(.1).timeout
	elif(GlobalScript.PlayerNode[order-1].StunTracker != 0):
			GlobalScript.DebugScript.add("CPU stunned and cannot move")

func show_possible_moves(pos):
	for tile in tile_map_node.get_surrounding_cells(pos):
		if TileCheck(tile):
			highlight_node.set_cell(tile, 16, Vector2i(0,0))
	
func hide_possible_moves():
	highlight_node.clear()
