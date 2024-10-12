extends Node
@export var Turn_Order = 1
signal order
@export var numPlayers = 2
var Scenes : Array
var drawcard : bool = false

var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")
#Getting the tile map from the current scene when this node is ready
@onready var TileMapScene =  get_node("../TileMap")

#Getting the turn buttons from the scene when this node is ready
@onready var EndTurnButton = get_node("../CanvasLayer/Button")
@onready var DrawButton = get_node("../CanvasLayer/Draw Card")
@onready var AttackButton = get_node("../CanvasLayer/Attack")
@onready var HandButton = get_node("../CanvasLayer/Show Hand")

#This could be used for signals and such for spawning players
@export var player_scene : PackedScene


#Card stuff
@export var HiredGunVar = 3
@export var WeaponCardVar = 5


@export var DrawArray = ["Td1","Td2","Td3", "Td4", "Td5", "Td6","Td7","Td8","Td9","Td10","Td11","Td12",]
@export var DiscardArray = []

@export var GunslingerArray = ["Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6"]
@export var HiredGunArray = ["HGun1","HGun2","HGun3","HGun4","HGun5","HGun6","HGun7","HGun8","HGun9","HGun10","HGun11","HGun12"]
@export var WeaponArray = ["Rifle1","Rifle2","Rifle3","Rifle4","Knife1","Knife2","Knife3","Knife4","Pistol1","Pistol2","Pistol3","Pistol4","Shotgun1","Shotgun2","Shotgun3","Shotgun4","TwinPistol1","TwinPistol2"]

@export var Check = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DrawArray.shuffle()
	#_drawTownDeck.rpc()
	
		#Counter variable, index
	var index = 0
	#Goes through the preloaded script MultiplayerManager which has the player info for the
	#peers that joined
	for i in GlobalScript.PlayerInfo:
		#Create a player instance
		var currentPlayer = player_scene.instantiate()
		currentPlayer.tile_map_node = get_node("../Layer0")
		#Change the name of the instance to the ID of the player
		currentPlayer.name = str(GlobalScript.PlayerInfo[i].ID)
		#Make the instance a child to this node
		add_child(currentPlayer)
		GlobalScript.PlayerNode.append(get_node(str(GlobalScript.PlayerInfo[i].ID)))
		#PArts of this could berun at different times for instance Host =/= player 1
		#Mario party roll to see who starts system
		if index == 0:
			#Player 1 information
			#Set player 1 at position 0,0 on the tile map
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (0,0))
			GlobalScript.PlayerNode[index].pos = Vector2 (0,0)
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Set it to player 1
			currentPlayer.Player_ID = 1
			
		if index == 1:
			#The next player in the PlayerInfo array, player 2
			#Sets player 2 at a different position from player 1
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (0,3))
			GlobalScript.PlayerNode[index].pos = Vector2 (0,3)
			#Sets the label to the name player 2 picked
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Sets it as player 2
			currentPlayer.Player_ID = 2
		#After each player increase the index for the next player to get proper information
		index += 1
	#Setting the turn order 1 to start
	Turn_Order = 1

	
	#IT WORKS!!!!!
	# I FEEL BOTH INCREDIBLY SMART AND SO SO SO DUMB
	
	for i in GlobalScript.PlayerInfo:
		GlobalScript.PlayerNode.append(get_node(str(GlobalScript.PlayerInfo[i].ID)))
	
	order.emit(Turn_Order)
	GlobalScript.DebugScript.add("-------  Player 1's Turn  -----------")
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	#Incremements Turn Order and sues RPC to make sure both the peeers and local machine are updated
	order_inc.rpc()
	order.emit(Turn_Order)
	pass # Replace with function bod
	


	#Function for incrementing turns
	#RPC that updates the peers and local machine
@rpc("any_peer", "call_local")
func order_inc():
	if(GlobalScript.PlayerNode[Turn_Order -1].StunTracker != 0):
		GlobalScript.PlayerNode[Turn_Order-1].StunTracker -= 1
	#Increment turn order
	Turn_Order = Turn_Order + 1
	#BEcuase there are only 2 players at turn 2 go back to turn 1
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	GlobalScript.DebugScript.add("-------  Player "+str(Turn_Order)+"'s Turn  -----------")
	_drawTownDeck()
	drawcard = false
	
	# gets postion of all player nodes
	#for i in GlobalScript.PlayerInfo.size():
	#	print(str(GlobalScript.PlayerNode[i].pos))
	
	#Send out a signal so all players know what turn it is
	order.emit(Turn_Order)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in numPlayers:
		if (GlobalScript.PlayerNode[n].Health <= 0):
			get_tree().quit()
	pass



func _onCardDraw() -> void:
	_drawTownDeck.rpc()
	'''
	if(!drawcard):
		var CardNum = randi()%52+1
		GlobalScript.DebugScript.add("Player "+str(Turn_Order)+" drew card "+str(CardNum))
		Scenes[Turn_Order -1].Player.add_card(CardNum)
		drawcard = true
		'''


func _ClaimCards() -> void:
	GlobalScript.DebugScript.add("Player "+str(Turn_Order)+" cards")
	for CardVal in Scenes[Turn_Order -1].Player.Cards:
		GlobalScript.DebugScript.add(str(CardVal))
		
		
#The RPC updates the health of the local player and all the players it can see
#It also updates for all the ppers so they see the proper health for all their player instances
@rpc("any_peer","call_local")
func Attack_Calc(n):
	var damage = GlobalScript.PlayerNode[n].WeaponDmg
	GlobalScript.PlayerNode[n].Health -= damage
	GlobalScript.DebugScript.add("Player "+str(n+1)+" lost "+str(damage)+" points of hp")
	GlobalScript.DebugScript.add("Player "+str(n+1)+" now has "+str(GlobalScript.PlayerNode[n].Health)+" points of hp")
	if(GlobalScript.PlayerNode[n].Health <= 0):
		GlobalScript.PlayerNode[n].Health = 0
	pass
	

@rpc("any_peer","call_local")
func StunPlay(n):
	GlobalScript.PlayerNode[n].StunTracker += GlobalScript.PlayerNode[Turn_Order -1].WeaponStun
	pass


func Attack() -> void:
	var Attacked = false;
	#Calls the function and makes sure it takes the rpc calls
	for n in numPlayers:
		if(n+1 != Turn_Order && !Attacked && GlobalScript.PlayerNode[Turn_Order-1].StunTracker ==0):
			# Current player position checking to match A players position
			if(DistCheck(n) && GlobalScript.PlayerNode[n].Health != 0 && GlobalScript.PlayerNode[Turn_Order -1].action_points !=0 && GlobalScript.PlayerNode[n].StunTracker == 0):
				Attacked = true;
				GlobalScript.PlayerNode[Turn_Order -1].action_points -= 1
				
				var Attack = (randi()%6 + 1)
				if(Attack < 3): # Miss
					GlobalScript.DebugScript.add("Target was missed")
				elif(Attack < 5): # Stun
					GlobalScript.DebugScript.add("Target was stunned")
					StunPlay.rpc(n)
				else:
					Attack_Calc.rpc(n)
			elif(GlobalScript.PlayerNode[n].StunTracker != 0):
				GlobalScript.DebugScript.add("Player is Stunned, you cannot attack ")
		elif(GlobalScript.PlayerNode[Turn_Order -1].action_points == 0):
			GlobalScript.DebugScript.add("You have no more Action Points ")
		elif(!DistCheck(n)):
			GlobalScript.DebugScript.add("Target Not in Range")
		elif(GlobalScript.PlayerNode[n].StunTracker != 0):
			GlobalScript.DebugScript.add("You are Stunned, you cannot attack ")

func DistCheck(player) -> bool:
	var PlayerLoc = GlobalScript.PlayerNode[Turn_Order -1].pos
	var EnemyLoc = GlobalScript.PlayerNode[player].pos
	var Dist = 2
	if(PlayerLoc == EnemyLoc):
		return true
	elif (EnemyLoc.y == PlayerLoc.y && (EnemyLoc.x >= PlayerLoc.x - Dist && EnemyLoc.x <= PlayerLoc.x + Dist)):
		return true
	elif (EnemyLoc.x == PlayerLoc.x && (EnemyLoc.y >= PlayerLoc.y - Dist && EnemyLoc.y <= PlayerLoc.y + Dist)):
		return true
	else:
		return false


func _input(event):
	if(event.is_action_pressed("Dynamite")):
		print("BOOM")
		"""
		for n in numPlayers:
			if(n+1 != Turn_Order):
				if(Scenes[Turn_Order-1].Player.location == Scenes[n].Player.SpawnLoc && Scenes[Turn_Order-1].Player.ActionPoint !=0):
					get_tree().quit()
				elif(Scenes[Turn_Order-1].Player.ActionPoint == 0):
					GlobalScript.DebugScript.add("You have no more Action Points ")
				elif(Scenes[Turn_Order-1].Player.location != Scenes[n].Player.SpawnLoc):
					GlobalScript.DebugScript.add("You are not on a player stable")
		"""




@rpc("any_peer","call_local")
func _drawTownDeck(): # fucntion that simulates the cards being drawn

	var DrawSize = DrawArray.size() # Checks size of the array we're drawing from
	if (DrawSize != 0): # first element exists -> array has some cards left
		var TDCard = DrawArray[0] # gets the first element value
		GlobalScript.DebugScript.add("DrawArray drew  "+str(TDCard))
		DrawArray.pop_front() #pop it out
		DiscardArray.push_front(TDCard) #push on discard array
		GlobalScript.DebugScript.add("DiscardArray has  "+str(DiscardArray))
		GlobalScript.DebugScript.add("DrawArray has  "+str(DrawArray))
#for n in DrawSize-1: # (in theory) should loop through the array and "push" everything up one spot in the array
#DrawArray[n] = DrawArray[n+1]
	else:
		for n in 12:
			DrawArray.push_front(DiscardArray[n]) #(dont think this works like I think it does) copy contents from discard back to draw
		DiscardArray.clear()
		DrawArray.shuffle() # shuffles the array contents
		var TDCard = DrawArray[0] #since its and if/else, we need to run the code from the if, or else the player would simply not be able to have a card drawn
		DrawArray.pop_front()
		DiscardArray.push_front(TDCard)
		GlobalScript.DebugScript.add("DiscardArray has  "+str(DiscardArray))
		GlobalScript.DebugScript.add("DrawArray has  "+str(DrawArray))
#for n in DrawSize-1:
#DrawArray[n] = DrawArray[n+1]

func _onStartDraw(player_index: int) -> void:
	var gunslinger_card = GunslingerArray[randi() % GunslingerArray.size()]
	GlobalScript.DebugScript.add("Player " + str(player_index) + " drew card " + gunslinger_card)
	GunslingerArray.erase(gunslinger_card)  # Remove the drawn card
	for i in range(3):
		var hired_gun_index = randi() % HiredGunArray.size()
		var hired_gun_card = HiredGunArray[hired_gun_index]
		GlobalScript.DebugScript.add("Player " + str(player_index) + " drew card " + hired_gun_card)
		Scenes[player_index - 1].Player.add_card(hired_gun_card)
		HiredGunArray.erase(hired_gun_card)  # Remove the drawn card
		
	for i in range(5):
		var weapon_index = randi() % WeaponArray.size()
		var weapon_card = WeaponArray[weapon_index]
		GlobalScript.DebugScript.add("Player " + str(player_index) + " drew card " + weapon_card)
		Scenes[player_index - 1].Player.add_card(weapon_card)
		WeaponArray.erase(weapon_card)  # Remove the drawn card
