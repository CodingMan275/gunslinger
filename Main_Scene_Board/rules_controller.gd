extends Node
#Sets the turn order for the game
@export var Turn_Order = 1
#Creates a signal to be sent out which will contain the information
#On turn order to other nodes and scenes

@onready var Victory = $"../Victory"
signal order

signal move

#Sets what the current amount of players is
#Will be changed to GlobalScript.PlayerInfo.size() in later functions
@export var numPlayers = 2

#Card stuff
#var Scenes : Array
var drawcard : bool = false
var accuracy : int


#var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")

#Getting the tile map from the current scene when this node is ready
@onready var TileMapScene =  get_node("../Player_Layer")
@onready var HighlightScene =  get_node("../Highlight_Layer")

#Getting the turn buttons from the scene when this node is ready
@onready var EndTurnButton = get_node("../CanvasLayer/Button")
@onready var DrawButton = get_node("../CanvasLayer/Draw Card")

@onready var AttackUI = get_node("../AttackingCanvas")
@onready var RangeButton = get_node("../AttackingCanvas/Range")
@onready var BrawlButton = get_node("../AttackingCanvas/Brawl")
@onready var BackButton = get_node("../AttackingCanvas/Back")
@onready var AttackButton = get_node("../CanvasLayer/Attack")

@onready var HandButton = get_node("../CanvasLayer/Show Hand")
@onready var DynamiteButton = get_node("../CanvasLayer/Dynamite")
@onready var MoveButton = get_node("../CanvasLayer/Move")
@onready var ClaimButton = get_node("../CanvasLayer/Claim")
@onready var GiveTakeButton = get_node("../CanvasLayer/Give_Take")

@onready var CardDecks = get_node("../Cards")
@onready var Townie = get_node("../Townie_Logic")
@onready var Canvas = get_node("../CanvasLayer")
@onready var Setup = get_node("../StartUpCanvas")
@onready var Profic = get_node("../ProficiencyNode")
@onready var Hurt = $"../CanvasLayer/Attack/HurtSFX"
@onready var DiceRoll = $"../CanvasLayer/Attack/DiceRollSFX"
@onready var Miss = $"../CanvasLayer/Attack/MissSFX"
@onready var EndTurn = $"../CanvasLayer/Button/EndTurnSFX"
@onready var Walking = $"../CanvasLayer/Move/WalkSFX"
@onready var Stun =$"../CanvasLayer/Attack/StunSFX"
@onready var VictoryMusic = get_node("/root/GlobalScript")
@onready var PlayerGuy = get_child(Turn_Order)


@export var AttackerProf : int
#The Player scene which will be instantiated and used for spawning in
#All peer players
@export var player_scene : PackedScene
@export var CPU_scene : PackedScene

var DisplayArray = []

signal guyClicked

var Attacker: Node2D
var Target : Node2D
var TargetGunSlinger : bool
var FirstDeath : bool = false

#region Start Up System

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Testing")
	if multiplayer.is_server() || GlobalScript.SinglePlay:
		$"../StartUpCanvas".show()
	NoTownies()
	

func DeleteLater():
	if GlobalScript.SinglePlay:
		_StartGame()
	else:
		_StartGame.rpc()


@rpc("any_peer","call_local")
func _StartGame() -> void:
	Setup.hide()
	Canvas.show()
	ShowTownies()
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
		for i in 2:
			SinglePlay(i, index)
			index += 1

	if(multiplayer.is_server()):
		CardDecks._onStartDraw()
	#Setting the turn order 1 to start
	#Redundant but safe
	Turn_Order = 1
	SelectAttacker.rpc(str(GlobalScript.PlayerNode[Turn_Order-1].Name))
	#Tell all the player scene instances what the current turn order is
	order.emit(Turn_Order)
	#In the little debug pop-up after pressing ~ it says this
	GlobalScript.DebugScript.add("-------  Player 1's Turn  -----------")
	pass # Replace with function body.


func MultiPlay(i , index):
		#Create a player instance
		var currentPlayer = player_scene.instantiate()
		#The player needs to get information from the tile map
		currentPlayer.tile_map_node = TileMapScene
		currentPlayer.highlight_node = HighlightScene
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
			var Start = Vector2(1,1)
			currentPlayer.position = TileMapScene.map_to_local(Start)
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Start
			GlobalScript.PlayerNode[index].Startpos = Start
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = 1
			
		if index == 1:
			#The next player in the PlayerInfo array, player 2
			#Sets player 2 at a different position from player 1
			var Start = Vector2(6,6)
			currentPlayer.position = TileMapScene.map_to_local(Start)
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Start
			GlobalScript.PlayerNode[index].Startpos = Start
			#Sets the label to the name player 2 picked
			currentPlayer.LabelName = GlobalScript.PlayerInfo[i].name
			#Sets it as player 2
			currentPlayer.Player_ID = 2
		
		
		# Set up that is not co dependent on a set index
		#GlobalScript.PlayerNode[index].Startpos = GlobalScript.PlayerNode[index].pos
		
		#After each player increase the index for the next player to get proper information

func SinglePlay(i , index):
		if index == 0:
			#await get_tree().create_timer(.2).timeout
			var currentPlayer = player_scene.instantiate()
			#The player needs to get information from the tile map
			currentPlayer.tile_map_node = TileMapScene
			currentPlayer.highlight_node = HighlightScene
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
			var Start = Vector2 (1,1)
			currentPlayer.position = TileMapScene.map_to_local(Start)
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Start
			GlobalScript.PlayerNode[index].Startpos = Vector2 (1,1)
			#Set player label to the name they put in (not needed but fun)
			currentPlayer.LabelName = "player"
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = 1
		if index > 0:
			print("Create cpu")
			var currentPlayer = CPU_scene.instantiate()
			#The player needs to get information from the tile map
			currentPlayer.tile_map_node = TileMapScene
			#Had to comment this out becuase its messing with cpu for testing
			currentPlayer.highlight_node = HighlightScene
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
			var Start = Vector2(6,6)
			currentPlayer.position = TileMapScene.map_to_local(Start)
			#Ask michael, sets player node position to somewhere
			GlobalScript.PlayerNode[index].pos = Start
			GlobalScript.PlayerNode[index].Startpos = Start
			GlobalScript.PlayerNode[index].TargetStable = Vector2(7-GlobalScript.PlayerNode[index].Startpos.x,7-GlobalScript.PlayerNode[index].Startpos.y)
			#Set player label to the name they put in (not needed but fun)
	#		currentPlayer.LabelName = "CPU"
			#Set it to player 1 which is effectively turn order
			currentPlayer.Player_ID = index + 1

#CPU is not townie ready so we will hide them
func NoTownies():
	for i in Townie.get_child_count():
		Townie.get_child(i-1).hide()

func ShowTownies():
	for i in 12:
		UpdateTownie.rpc(Townie.get_child(i))
		Townie.get_child(i).show()

#endregion

@rpc ("any_peer" , "call_local")
func UpdateTownie(townie : Node2D):
	townie.SpawnLoc = townie.tile_map_node.local_to_map(townie.position)
	townie.pos = townie.SpawnLoc



func _on_button_pressed() -> void:
	#Incremements Turn Order and uses RPC to make sure both the peeers and local machine are updated
	#EndTurn.play()
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
		GlobalScript.PlayerNode[Turn_Order -1].FreeBrawl = true
	#Increment turn order
	Turn_Order = Turn_Order + 1
	#BEcuase there are only 2 players at turn 2 go back to turn 1
	#We can change this to like GlobalScript.PlayerInfo.Size() + 1 but im lazy
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	#Menu says whos turn it is
	ClaimButton.hide()
	GlobalScript.DebugScript.add("-------  "+str(GlobalScript.PlayerNode[Turn_Order -1].Name)+"'s Turn  -----------")
	SelectAttacker.rpc(str(GlobalScript.PlayerNode[Turn_Order-1].Name))
	#Send out a signal so all players know what turn it is
	order.emit(Turn_Order)





#This Function needs to reset everything or start up needs to clear everything
@rpc("any_peer", "call_local")
func Winner(con : int , Quit : bool):
	# Con is the turn Order , and if con is less than 0 it was a force quit
	print("Con is: ",con," and Quit is: ",Quit )
	if con > 0 :
		if (con == 1 && !Quit) || (con == 2 && Quit) :
			get_tree().change_scene_to_file("res://Victory_Screens/player1_victory_screen.tscn")
		if (con == 2 && !Quit) || (con == 1 && Quit):
			if(!GlobalScript.SinglePlay):
				get_tree().change_scene_to_file("res://Victory_Screens/player2_victory_screen.tscn")
			else:
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://Victory_Screens/CPU2_victory_screen.tscn")
		#Victory.play()
		if !GlobalScript.SinglePlay:
			get_parent().queue_free()
	else:
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	GlobalScript.clear()



#Unclear what this does, ask michael / Oakley
func _ClaimCards() -> void:
	CardDecks._ClaimCards(Turn_Order-1)
	
	
	
func DisplayCards():
	
	pass


#region Attacking and Dynamite

# Assigns a Townie as a target
@rpc("any_peer","call_local")
func SelectTownie(guy : String) -> void:
	TargetGunSlinger = false
	Target = Townie.get_node(guy)
	guyClicked.emit()
	GlobalScript.DebugScript.add("You targeted "+guy)

#Assigns a Gunslinger as a Target
@rpc("any_peer","call_local")
func SelectGunslinger(guy : int) -> void:
	TargetGunSlinger = true
	
	Target = GlobalScript.PlayerNode[guy-1]
	GlobalScript.DebugScript.add("You targeted Player "+str(guy))

#This will Swap the Attacker and Target. (Mainly used for Brawling)
@rpc("any_peer","call_local")
func SwapAttacking()-> void:
	var Swap = Target
	Target = Attacker
	Attacker = Swap 

#Assigment of the Attacker
@rpc("any_peer","call_local")
func SelectAttacker(guy : String) -> void:
	AttackerProf = 0
	var isplayer = false
	for i in GlobalScript.PlayerNode.size():
		if GlobalScript.PlayerNode[i].Name == guy:
			isplayer = true
			Attacker = GlobalScript.PlayerNode[i]
			AttackerProf += Profic.GunslingerProficiencyCalc(i)
	if !isplayer:
		Attacker = Townie.get_node(guy)
		AttackerProf += Profic.TownieProficiencyCalc(guy)

func RangeAttack(Name : String) -> bool:
	#Replace for loop with clicking a sprite
	#Where n will be the target selected
	var ReturnBool = false
	if Target != null:
		if Name == "Player":
			SelectAttacker.rpc(GlobalScript.PlayerNode[Turn_Order -1].Name)
		else:
			SelectAttacker.rpc(Name)
		var range= Attacker.Weapon1Range
		if range != 0:
			if(TileMapScene.Boardwalk(Attacker.pos)):
				print("The range was increased by one")
				range+1
			if CanAttack(range):
				ReturnBool = true
				Attacker.action_points -= 1 
				GlobalScript.DebugScript.add(str(Attacker.Name)+" Attacked "+str(Target.Name))
				GlobalScript.DebugScript.add(str(Attacker.Name)+" has "+str(Attacker.action_points) + " action points left ")
				Attack()
				
			else:
				CantAttack(range)
				ReturnBool = false
		else:
			CantAttack(range)
			ReturnBool = false
	return ReturnBool

func BrawlAttack(Name : String) -> bool:
	#target == "teacher"
	var ReturnBool = false
	#Replace for loop with selected target
	#n being the target
	if Target != null:
		if Name == "Player":
			SelectAttacker.rpc(GlobalScript.PlayerNode[Turn_Order -1].Name)
		else:
			SelectAttacker.rpc(Name)
		if CanAttack(0):
			if(!Attacker.FreeBrawl):
				Attacker.action_points -= 1
				GlobalScript.DebugScript.add(str(Attacker.Name)+" Attacked "+str(Target.Name))
				GlobalScript.DebugScript.add(str(Attacker.Name)+" has "+str(Attacker.action_points) + " action points left ")
			Attacker.FreeBrawl = false
			Attack()
			SwapAttacking.rpc()
			Attack()
			SwapAttacking.rpc()
			ReturnBool = true
		else:
			CantAttack(0)
			ReturnBool = false
	return ReturnBool

#Detects if the player is capable of attacking
func CanAttack(range) -> bool:
	return (Attacker.StunTracker ==0 && !Attacker.DrewCard && Attacker.action_points !=0 && DistCheck(range) && Target.StunTracker == 0)

#States why a player cannot attack
func CantAttack(range) -> void:
	#You have no action points, stop that
	if(Attacker.action_points == 0):
		GlobalScript.DebugScript.add(str(Attacker.action_points) + " has no more Action Points ")
	#You drew a card and cannot attack
	elif(Attacker.DrewCard):
		GlobalScript.DebugScript.add(str(Attacker.action_points) + " cannot act because they drew a card")
	#Youre stunned silly
	elif(Attacker.StunTracker != 0):
		GlobalScript.DebugScript.add(str(Attacker.action_points) + " is Stunned and cannot attack ")
	#The playerer youre trying to attack is stunned, cant attack them
	elif(Target.StunTracker != 0):
		GlobalScript.DebugScript.add(str(Target.Name + " is Stunned, you cannot attack "))
	#The player you are trying to attack is not in range
	elif(!DistCheck(range)):
		GlobalScript.DebugScript.add(str(Target.Name + " is Not in Range"))

#Attack function
func Attack() -> void:
	DrawButton.hide()
	#DiceRoll.play()
	#Random attack ccheck
	var Attack = (randi()%6 + 1)
	accuracy = 0
	print("before", Attack)
	print("AttackProf", AttackerProf)
	#You are shooting at someone on a boardwalk
	if(TileMapScene.Path(Attacker.pos) && TileMapScene.Boardwalk(Target.pos)):
		GlobalScript.DebugScript.add("The accuracy was decreased by one")
		accuracy -=1
	#If you are not in the same building as them
	if TileMapScene.Building(Target.pos) && !TileMapScene.SameBuilding(Attacker.pos , Target.pos) :
		GlobalScript.DebugScript.add("The accuracy was decreased by two")
		accuracy -=2
	Attack += accuracy + AttackerProf
	print("accuracy", accuracy)
	if(Attack < 3): # Miss
		Miss.play()
		GlobalScript.DebugScript.add(str(Target.Name + " was missed"))
	elif(Attack < 5): # Stun
		Stun.play()
		GlobalScript.DebugScript.add(str(Target.Name + " was stunned"))
	#Rpc function call
		StunPlay.rpc()
	else:
		#Attack hit, rpc function call
		Hurt.play()
		var damage = Attacker.Weapon1Dmg
		Attack_Calc.rpc(damage)
	print("after", Attack)
	

#The RPC updates the health of the local player and all the players it can see
#It also updates for all the ppers so they see the proper health for all their player instances
@rpc("any_peer","call_local")
func Attack_Calc(damage):
	#take weapon damage from what the attacking player is holding
	#Damage the player accordingly
	#Also logic error? Its taking the the player thats getting attack
	#Weapon damage, not the attacking players?
	Target.Health -= damage
	if !TargetGunSlinger:
		Target.HealthCheck.rpc()

	'''
	if GlobalScript.PlayerNode[Enemy].Health <= 0:
		GlobalScript.PlayerNode[Enemy].Health = 0
		GlobalScript.PlayerNode[Enemy].PlayerHand.clear()
	'''
	'''
	# How to get a players townie
	if TargetGunSlinger:
		for x in 3:
			var HGUN = Townie.get_node(Attacker.PlayerHand[x+1])
			print(HGUN.name)
	'''
	#Debug enu to show damage
	GlobalScript.DebugScript.add(Target.Name + " lost "+str(damage)+" points of hp")
	GlobalScript.DebugScript.add(Target.Name + " now has "+str(Target.Health)+" points of hp")
	if Target.Health <= 0 && TargetGunSlinger:
		#Checks to see if Gunslinger Claimed anyone
		var HasTownie = false
		'''
		for i in 3:
			if Townie.get_node(Attacker.PlayerHand[i+1]).claim_revealed:
				HasTownie = true
				
		'''
		'''
		#Give pre first death Claimed Townies the ability to dynamite
		if !FirstDeath && !GlobalScript.SinglePlay:
			FirstDeath = true
			for i in 6:
				if Townie.get_node(GlobalScript.PlayerNode[int(i/3)].PlayerHand[int((i%3)+1)]).claim_revealed:
					Townie.get_node(GlobalScript.PlayerNode[int(i/3)].PlayerHand[int((i%3)+1)]).CanDynamite = true
		'''
		if !HasTownie:
			Winner.rpc(Turn_Order , false)
	pass

#Tell everybody which node got stunned
@rpc("any_peer","call_local")
func StunPlay():
	#A stun tracker to make sure a stunned player can't move
	Target.StunTracker += Attacker.Weapon1Stun
	pass


#Check the distance from you and the player youre looking at
func DistCheck(Dist) -> bool:
	#Currently hard coded for two players
	var PlayerLoc = Attacker.pos
	var EnemyLoc = Target.pos
	#Cannot shoot trough thick walls
	if (TileMapScene.WalledBuilding(PlayerLoc) || TileMapScene.WalledBuilding(EnemyLoc)) && !TileMapScene.SameBuilding(PlayerLoc,EnemyLoc) && PlayerLoc.y == EnemyLoc.y:
		return false
	#Cannot attack people in jail and cannot attack from jail
	if TileMapScene.Jail(PlayerLoc) || TileMapScene.Jail(EnemyLoc):
		return false
	#Cannot Attack in Stables
	if TileMapScene.Stable(PlayerLoc) || TileMapScene.Stable(EnemyLoc):
		return false
	
	#This checks to see if we shoot over a building  or a boardwalk. If its a building we cant shoot, and if its a boardalk we lose one accuracy point
	for i in Dist:
		if EnemyLoc.y == PlayerLoc.y && TileMapScene.Path(PlayerLoc) && TileMapScene.Path(EnemyLoc):
			if (TileMapScene.Building(Vector2(PlayerLoc.x + i,PlayerLoc.y)) && PlayerLoc.x <= EnemyLoc.x) || (TileMapScene.Building(Vector2(PlayerLoc.x - i,PlayerLoc.y)) && PlayerLoc.x >= EnemyLoc.x):
				return false
			elif ((TileMapScene.Boardwalk(Vector2(PlayerLoc.x + i,PlayerLoc.y)) && PlayerLoc.x <= EnemyLoc.x) || (TileMapScene.Boardwalk(Vector2(PlayerLoc.x - i,PlayerLoc.y)) && PlayerLoc.x >= EnemyLoc.x)) && accuracy == 0:
				accuracy -=1
		elif EnemyLoc.x == PlayerLoc.x && TileMapScene.Path(PlayerLoc) && TileMapScene.Path(EnemyLoc):
			if (TileMapScene.Building(Vector2(PlayerLoc.x,PlayerLoc.y+i)) && PlayerLoc.y <= EnemyLoc.y) || (TileMapScene.Building(Vector2(PlayerLoc.x,PlayerLoc.y -i)) && PlayerLoc.y >= EnemyLoc.y):
				return false
			elif ((TileMapScene.Boardwalk(Vector2(PlayerLoc.x,PlayerLoc.y +i)) && PlayerLoc.y <= EnemyLoc.y) || (TileMapScene.Boardwalk(Vector2(PlayerLoc.x ,PlayerLoc.y -i)) && PlayerLoc.y >= EnemyLoc.y)) && accuracy == 0:
				accuracy -=1
	
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
func Dynamite() -> bool:
	if(StableCheck() && GlobalScript.PlayerNode[Turn_Order -1].action_points !=0 && !GlobalScript.PlayerNode[Turn_Order-1].DrewCard && Attacker.CanDynamite):
		if(!GlobalScript.SinglePlay):
			Winner.rpc(Turn_Order ,false)
		else: 
			Winner(Turn_Order , false)
		return true
	elif(GlobalScript.PlayerNode[Turn_Order-1].DrewCard):
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Turn_Order -1].Name) + " cannot act because of drawing a card")
	elif(GlobalScript.PlayerNode[Turn_Order -1].action_points == 0):
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Turn_Order -1].Name) + " has no more Action Points ")
	elif(!StableCheck()):
		GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[Turn_Order -1].Name) + " is not on a enemy stable")
	return false

func StableCheck() -> bool:
	var PlayerLoc = GlobalScript.PlayerNode[Turn_Order -1].pos
	var EnemyLoc = Vector2(7-GlobalScript.PlayerNode[Turn_Order -1].Startpos.x,7-GlobalScript.PlayerNode[Turn_Order -1].Startpos.y)
	if(EnemyLoc.x < 2 && PlayerLoc. x <= 2 && PlayerLoc.y <=2 && PlayerLoc != Vector2(2,2)):
			return true
	elif(EnemyLoc.x > 5 && PlayerLoc. x >= 5 && PlayerLoc.y >=5 && PlayerLoc != Vector2(5,5)):
			return true
	else:
		return false

#endregion

func _on_move_pressed() -> void:
	#Walking.play()
	if(!GlobalScript.SinglePlay):
		movePossible.rpc()
	else:
		movePossible()
	
	pass # Replace with function body.
	
@rpc("call_local","any_peer")
func movePossible():
	move.emit()
	pass

func PlayerUI(vis : bool) -> void :
	AttackButton.visible = !vis
	AttackUI.visible = vis
func playWalk():
	Walking.play()


#############################
#############################
#############################

"""
	2. Each one of those nodes, needs to implement the following three functions
   a. get_save_id() : returns a unique id for this node as a string.
	  Apparently, Godot does not have UUIDs, so we have to make our own.
"""
func get_save_id():
	return "rules_controller"

"""
   b. save(): this methods returns a dictionary with the data that node
	  needs to save/restore during gameplay.
	  Here is an example from an unrelated game
"""
func save():
	var save_dict = {
		"Turn_Order" : Turn_Order,
		"numPlayers" : numPlayers,
		"drawcard" : drawcard,
		"accuracy" : accuracy,
		"AttackerProf" : AttackerProf,
		"DisplayArray" : DisplayArray,
		"TargetGunSlinger" : TargetGunSlinger,
		"FirstDeath" : FirstDeath
	}
	
	return save_dict


"""
	c. restore(saved_data): this method gets a dictionary of previously saved data
	   and uses it to restore the state of the node. This is the same dictonary
	   structure returned by save().
"""
func restore(saved_data):
	Turn_Order =saved_data["Turn_Order"]
	numPlayers =saved_data["numPlayers"]
	drawcard =saved_data["drawcard"]
	accuracy =saved_data["accuracy"]
	AttackerProf =saved_data["AttackerProf"]
	DisplayArray =saved_data["DisplayArray"]
	TargetGunSlinger =saved_data["TargetGunSlinger"]
	FirstDeath =saved_data["FirstDeath"]
