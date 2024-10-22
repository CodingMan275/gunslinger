extends Node
#Sets the turn order for the game
@export var Turn_Order = 1
#Creates a signal to be sent out which will contain the information
#On turn order to other nodes and scenes
signal order

#Sets what the current amount of players is
#Will be changed to GlobalScript.PlayerInfo.size() in later functions
@export var numPlayers = 2

#Card stuff
#var Scenes : Array
var drawcard : bool = false

#var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")

#Getting the tile map from the current scene when this node is ready
#@onready var TileMapScene =  get_node("../TileMap")

#Getting the turn buttons from the scene when this node is ready
@onready var EndTurnButton = get_node("../CanvasLayer/Button")
@onready var DrawButton = get_node("../CanvasLayer/Draw Card")
@onready var RangeButton = get_node("../CanvasLayer/Attack")
@onready var BrawlButton = get_node("../CanvasLayer/Brawl")
@onready var HandButton = get_node("../CanvasLayer/Show Hand")
@onready var DynamiteButton = get_node("../CanvasLayer/Dynamite")

@onready var CardDecks = get_node("../Cards")
@onready var Townie = get_node("../Townie_Logic")

#The Player scene which will be instantiated and used for spawning in
#All peer players
@export var player_scene : PackedScene
@export var CPU_scene : PackedScene



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Counter variable
	var index = 0
	#Goes through the preloaded script GlobalScript which has the player info for the
	#peers that joined including name and ID, the ID comes form godots randomly assigned
	#peer ID which is basically any positive number greater than 1. The host
	#is ALWAYS peer ID 1.
	
	if(!GlobalScript.SinglePlay):
		for i in GlobalScript.PlayerInfo:
			MultiPlay(i, index)
			index += 1
	else:
		for i in numPlayers:
			SinglePlay(i, index)
			index += 1

	if(multiplayer.is_server()):
		CardDecks._onStartDraw()
	#Setting the turn order 1 to start
	#Redundant but safe
	Turn_Order = 1
	
	
	#Ok so basically what this does is we go through the the Global Script
	#to to go through all the players info starting at Player 1, we
	#Find player 1's ID and then set that INT to a String. We know
	#For a fact we set Player 1's Node in the scene to have the same name as its
	#ID So player 1's node is named "1", while player 2's maybe "323552154678"
	#We then go through the entire scene and then get the node with the name
	#of the ID of the current player we are looking at in this for loop.
	#We then take that node refrence and add it too a container. Im not sure
	#What the purpose of this is again, ask michael.
	#Any questions ask josh

	#Tell all the player scene instances what the current turn order is
	order.emit(Turn_Order)
	#In the little debug pop-up after pressing ~ it says this
	GlobalScript.DebugScript.add("-------  Player 1's Turn  -----------")
	pass # Replace with function body.




func MultiPlay(i , index):
		#Create a player instance
		var currentPlayer = player_scene.instantiate()
		#The player needs to get information from the tile map
		currentPlayer.tile_map_node = get_node("../Layer0")
		#Change the name of the instance to the ID of the player
		#This is important for getting which specific player we want
		currentPlayer.name = str(GlobalScript.PlayerInfo[i].ID)
		#Make the instance a child to this node, the player can now access what
		#the rules controller can access
		add_child(currentPlayer)
		#Unsure what this does, ask Michael
		GlobalScript.PlayerNode.append(get_node(str(GlobalScript.PlayerInfo[i].ID)))
		#Parts of this could be run at different times for instance Host =/= player 1
		#Mario party roll to see who starts system before index decides turn order
		#and such
		if index == 0:
			#Player 1 information
			#Set player 1 at position 0,0 on the tile map
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (2,2))
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Vector2 (2,2)
			GlobalScript.PlayerNode[index].Startpos = Vector2(1,1)
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = 1
			
		if index == 1:
			#The next player in the PlayerInfo array, player 2
			#Sets player 2 at a different position from player 1
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (2,2))
			#Once ask Michael, sorry this is not good commenting
			GlobalScript.PlayerNode[index].pos = Vector2 (2,2)
			GlobalScript.PlayerNode[index].Startpos = Vector2(6,6)
			#Sets the label to the name player 2 picked
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Sets it as player 2
			currentPlayer.Player_ID = 2
		
		
		# Set up that is not co dependent on a set index
		#GlobalScript.PlayerNode[index].Startpos = GlobalScript.PlayerNode[index].pos
		
		#After each player increase the index for the next player to get proper information

func SinglePlay(i , index):
		print(index)
		if index == 0:
			var currentPlayer = player_scene.instantiate()
			#The player needs to get information from the tile map
			currentPlayer.tile_map_node = get_node("../Layer0")
			#Change the name of the instance to the ID of the player
			#This is important for getting which specific player we want
			currentPlayer.name = "player"
			#Make the instance a child to this node, the player can now access what
			#the rules controller can access
			add_child(currentPlayer)
			#Unsure what this does, ask Michael
			GlobalScript.PlayerNode.append(get_node("player"))
			#Parts of this could be run at different times for instance Host =/= player 1
			#Mario party roll to see who starts system before index decides turn order
			#and such
			#Player 1 information
			#Set player 1 at position 0,0 on the tile map
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (5,5))
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Vector2 (5,5)
			GlobalScript.PlayerNode[index].Startpos = Vector2(1,1)
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = "player"
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = 1
		if index > 0:
			print("Create cpu")
			var currentPlayer = CPU_scene.instantiate()
			#The player needs to get information from the tile map
			currentPlayer.tile_map_node = get_node("../Layer0")
			#Change the name of the instance to the ID of the player
			#This is important for getting which specific player we want
			currentPlayer.name = str("CPU " + str(index))
			#Make the instance a child to this node, the player can now access what
			#the rules controller can access
			add_child(currentPlayer)
			#Unsure what this does, ask Michael
			GlobalScript.PlayerNode.append(get_node(str("CPU " + str(index))))
			#Parts of this could be run at different times for instance Host =/= player 1
			#Mario party roll to see who starts system before index decides turn order
			#and such
			#Player 1 information
			#Set player 1 at position 0,0 on the tile map
			currentPlayer.position = get_node("../Layer0").map_to_local(Vector2 (0,7))
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Vector2 (0,7)
			GlobalScript.PlayerNode[index].Startpos = Vector2(6,6)
			#Set player label to the name they put in (not needed but fun)
	#		currentPlayer.LabelName = "CPU"
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = index + 1




func _on_button_pressed() -> void:
	#Incremements Turn Order and uses RPC to make sure both the peeers and local machine are updated
	if(!GlobalScript.SinglePlay):
		order_inc.rpc()
	else:
		order_inc()
	#Tell the player instance in the scene whos turn it is
	pass # Replace with function bod
	


#Function for incrementing turns
#RPC that makes all the peers run this function and the local machine
@rpc("any_peer", "call_local")
func order_inc():
	#If current node stunned, ask Michael
	if(GlobalScript.PlayerNode[Turn_Order -1].StunTracker != 0):
		GlobalScript.PlayerNode[Turn_Order-1].StunTracker -= 1
	#Increment turn order
	Turn_Order = Turn_Order + 1
	#BEcuase there are only 2 players at turn 2 go back to turn 1
	#We can change this to like GlobalScript.PlayerInfo.Size() + 1 but im lazy
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	#Menu says whos turn it is
	GlobalScript.DebugScript.add("-------  "+str(GlobalScript.PlayerNode[Turn_Order -1].Name)+"'s Turn  -----------")
	
	#Send out a signal so all players know what turn it is
	order.emit(Turn_Order)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Go through all the players and their health
	#If 0 end game,
	#Does not need to be run constantly we can make this
	#A signal thing, to do later
	
	for n in GlobalScript.PlayerNode.size():
		if (GlobalScript.PlayerNode[n].Health <= 0):
			KillAll.rpc()
			
	pass
	
@rpc("any_peer", "call_local")
func KillAll():
	get_tree().quit()


#Unclear what this does, ask michael / Oakley
func _ClaimCards() -> void:
	CardDecks._ClaimCards(Turn_Order-1)
		
#The RPC updates the health of the local player and all the players it can see
#It also updates for all the ppers so they see the proper health for all their player instances
@rpc("any_peer","call_local")
func Attack_Calc(Enemy, Player):
	#take weapon damage from what the attacking player is holding
	var damage = GlobalScript.PlayerNode[Player].WeaponDmg
	#Damage the player accordingly
	#Also logic error? Its taking the the player thats getting attack
	#Weapon damage, not the attacking players?
	GlobalScript.PlayerNode[Enemy].Health -= damage
	#Debug enu to show damage
	GlobalScript.DebugScript.add("Player "+str(Enemy+1)+" lost "+str(damage)+" points of hp")
	GlobalScript.DebugScript.add("Player "+str(Enemy+1)+" now has "+str(GlobalScript.PlayerNode[Enemy].Health)+" points of hp")
	#If overkill, dont
	if(GlobalScript.PlayerNode[Enemy].Health <= 0):
		GlobalScript.PlayerNode[Enemy].Health = 0
	pass
	
#Tell everybody which node got stunned
@rpc("any_peer","call_local")
func StunPlay(Enemy, Player):
	#A stun tracker to make sure a stunned player can't move
	GlobalScript.PlayerNode[Enemy].StunTracker += GlobalScript.PlayerNode[Player].WeaponStun
	pass


func RangeAttack():
	for n in numPlayers:
		if(n+1 != Turn_Order && CanAttack(n,GlobalScript.PlayerNode[Turn_Order -1].WeaponRange)):
			GlobalScript.PlayerNode[Turn_Order -1].action_points -= 1
			Attack(n , Turn_Order -1)
		else:
			CantAttack(n,GlobalScript.PlayerNode[Turn_Order -1].WeaponRange)

func BrawlAttack():
	for n in numPlayers:
		if(n+1 != Turn_Order && CanAttack(n,0)):
			if(!GlobalScript.PlayerNode[Turn_Order -1].FreeBrawl):
				GlobalScript.PlayerNode[Turn_Order -1].action_points -= 1
			GlobalScript.PlayerNode[Turn_Order -1].FreeBrawl = false
			Attack(n, Turn_Order -1)
			Attack(Turn_Order -1 , n)
		else:
			CantAttack(n , 0)

#Detects if the player is capable of attacking
func CanAttack(Enemy , range) -> bool:
	return (GlobalScript.PlayerNode[Turn_Order-1].StunTracker ==0 && GlobalScript.PlayerNode[Turn_Order-1].can_act && 
	GlobalScript.PlayerNode[Turn_Order -1].action_points !=0 && DistCheck(Enemy, range) && GlobalScript.PlayerNode[Enemy].StunTracker == 0)

#States why a player cannot attack
func CantAttack(Enemy , range) -> void:
	#You have no action points, stop that
	if(GlobalScript.PlayerNode[Turn_Order -1].action_points == 0):
		GlobalScript.DebugScript.add("You have no more Action Points ")
	#You drew a card and cannot attack
	elif(!GlobalScript.PlayerNode[Turn_Order-1].can_act):
		GlobalScript.DebugScript.add("You cannot act because you drew a card")
	#Youre stunned silly
	elif(GlobalScript.PlayerNode[Turn_Order -1].StunTracker != 0):
		GlobalScript.DebugScript.add("You are Stunned, you cannot attack ")
	#The playerer youre trying to attack is stunned, cant attack them
	elif(GlobalScript.PlayerNode[Enemy].StunTracker != 0):
			GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Enemy].Name + " is Stunned, you cannot attack "))
	#The player you are trying to attack is not in range
	elif(!DistCheck(Enemy , range)):
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Enemy].Name + " is Not in Range"))

#Attack function
func Attack(Enemy, Player) -> void:
	DrawButton.hide()
	#Random attack ccheck
	var Attack = (randi()%6 + 1)
	if(Attack < 3): # Miss
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Enemy].Name + " was missed"))
	elif(Attack < 5): # Stun
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Enemy].Name + " was stunned"))
	#Rpc function call
		StunPlay.rpc(Enemy, Player)
	else:
		#Attack hit, rpc function call
		Attack_Calc.rpc(Enemy, Player)


#Check the distance from you and the player youre looking at
func DistCheck(player, Dist) -> bool:
	#Currently hard coded for two players
	var PlayerLoc = GlobalScript.PlayerNode[Turn_Order -1].pos
	var EnemyLoc = GlobalScript.PlayerNode[player].pos
	#Same Y , X Detection
	if (EnemyLoc.y == PlayerLoc.y && (EnemyLoc.x >= PlayerLoc.x - Dist && EnemyLoc.x <= PlayerLoc.x + Dist)):
		return true
	#Same X, Y Detection
	elif (EnemyLoc.x == PlayerLoc.x && (EnemyLoc.y >= PlayerLoc.y - Dist && EnemyLoc.y <= PlayerLoc.y + Dist)):
		return true
	#Not in range orthangonially
	else:
		return false

#Throw dynamite, needs work
func Dynamite():
	if(StableCheck() && GlobalScript.PlayerNode[Turn_Order -1].action_points !=0 && GlobalScript.PlayerNode[Turn_Order-1].can_act):
		KillAll.rpc()
	elif(!GlobalScript.PlayerNode[Turn_Order-1].can_act):
		GlobalScript.DebugScript.add("You cannot act because you drew a card")
	elif(GlobalScript.PlayerNode[Turn_Order -1].action_points == 0):
		GlobalScript.DebugScript.add("You have no more Action Points ")
	elif(!StableCheck()):
		GlobalScript.DebugScript.add("You are not on a player stable")

func StableCheck():
	var PlayerLoc = GlobalScript.PlayerNode[Turn_Order -1].pos
	var EnemyLoc
	if (GlobalScript.PlayerNode[Turn_Order -1].Startpos == Vector2(1,1)):
		EnemyLoc = Vector2(6,6)
	else:
		EnemyLoc = Vector2(1,1)
	if(EnemyLoc.x < 2):
		if (PlayerLoc. x <= 2 && PlayerLoc.y <=2 && PlayerLoc != Vector2(2,2)):
			return true
	elif(EnemyLoc.x > 5):
		if (PlayerLoc. x >= 5 && PlayerLoc.y >=5 && PlayerLoc != Vector2(5,5)):
			return true
	else:
		return false
