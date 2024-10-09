extends Node
@export var Turn_Order = 1
signal order
@export var numPlayers = 2
var Scenes : Array
var drawcard : bool = false

var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")
#Getting the tile map from the current scene when this node is ready
@onready var TileMapScene =  get_node("../TileMap")
#Getting the end turn button from the scene when this node is ready
@onready var EndTurnButton = get_node("../CanvasLayer/Button")



#This could be used for signals and such for spawning players
@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	"""
	Turn_Order = 1
	
	for n in numPlayers:
		#Spawn Player
		var scene = PlayerScene.instantiate()
		scene.tile_map_node = get_node("../Layer0")
		Scenes.append(scene)
		Scenes[n].Player.ID = n+1
# Add the node as a child of the node the script is attached to.
		add_child(Scenes[n])

	Scenes[0].position = get_node("../Layer0").map_to_local(Vector2 (0,0))
	Scenes[0].Player.location = Vector2(0,0)
	Scenes[0].Player.SpawnLoc = Scenes[0].Player.location
	Scenes[1].position = get_node("../Layer0").map_to_local(Vector2 (7,7))
	Scenes[1].Player.location = Vector2(7,7)
	Scenes[1].Player.SpawnLoc = Scenes[1].Player.location
	"""
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
		#PArts of this could berun at different times for instance Host =/= player 1
		#Mario party roll to see who starts system
		if index == 0:
			#Player 1 information
			#Set player 1 at position 0,0 on the tile map
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (0,0))
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Set it to player 1
			currentPlayer.Player_ID = 1
		if index == 1:
			#The next player in the PlayerInfo array, player 2
			#Sets player 2 at a different position from player 1
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (4,4))
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
	#Increment turn order
	Turn_Order = Turn_Order + 1
	#BEcuase there are only 2 players at turn 2 go back to turn 1
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	GlobalScript.DebugScript.add("-------  Player "+str(Turn_Order)+"'s Turn  -----------")
	drawcard = false
	
	# gets postion of all player nodes
	#for i in GlobalScript.PlayerInfo.size():
	#	print(str(GlobalScript.PlayerNode[i].pos))
	
	#Send out a signal so all players know what turn it is
	order.emit(Turn_Order)




"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in numPlayers:
		if (Scenes[n].Player.Health <= 0):
			get_tree().quit()
	pass
"""




func _onCardDraw() -> void:
	if(!drawcard):
		var CardNum = randi()%52+1
		GlobalScript.DebugScript.add("Player "+str(Turn_Order)+" drew card "+str(CardNum))
		Scenes[Turn_Order -1].Player.add_card(CardNum)
		drawcard = true

func _ClaimCards() -> void:
	GlobalScript.DebugScript.add("Player "+str(Turn_Order)+" cards")
	for CardVal in Scenes[Turn_Order -1].Player.Cards:
		GlobalScript.DebugScript.add(str(CardVal))


func Attack() -> void:
	var Attacked = false;
	for n in numPlayers:
		if(n+1 != Turn_Order && !Attacked):
				# Current player position checking to match A players position
			if(DistCheck(n) && GlobalScript.PlayerNode[n].Health != 0 && GlobalScript.PlayerNode[Turn_Order -1].action_points !=0):
					# reduces A players health by [1...6]
				var damage = (randi()%6 + 1)
				GlobalScript.PlayerNode[n].Health -= damage
				Attacked = true
				GlobalScript.DebugScript.add("Player "+str(n+1)+" lost "+str(damage)+" points of hp")
				GlobalScript.DebugScript.add("Player "+str(n+1)+" now has "+str(GlobalScript.PlayerNode[n].Health)+" points of hp")
				GlobalScript.PlayerNode[Turn_Order -1].action_points -= 1
				if(GlobalScript.PlayerNode[n].Health <= 0):
					GlobalScript.PlayerNode[n].Health = 0
			elif(GlobalScript.PlayerNode[Turn_Order -1].action_points == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
			elif(!DistCheck(n)):
				GlobalScript.DebugScript.add("Target Not in Range")

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
