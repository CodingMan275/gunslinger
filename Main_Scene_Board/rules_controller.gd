extends Node

@export var Turn_Order = 1

signal order

@export var numPlayers = 2

var Scenes : Array
var drawcard : bool = false
var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")

@export var HiredGunVar = 3
@export var WeaponCardVar = 5


@export var DrawArray = ["Td1","Td2","Td3", "Td4", "Td5", "Td6","Td7","Td8","Td9","Td10","Td11","Td12",]
@export var DiscardArray = []

@export var GunslingerArray = ["Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6"]
@export var HiredGunArray = ["HGun1","HGun2","HGun3","HGun4","HGun5","HGun6","HGun7","HGun8","HGun9","HGun10","HGun11","HGun12"]
@export var WeaponArray = ["Rifle1","Rifle2","Rifle3","Rifle4","Knife1","Knife2","Knife3","Knife4","Pistol1","Pistol2","Pistol3","Pistol4","Shotgun1","Shotgun2","Shotgun3","Shotgun4","TwinPistol1","TwinPistol2"]
#This could be used for signals and such for spawning players
@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Turn_Order = 1
	
	
	for n in numPlayers:
		#Spawn Player
		var scene = PlayerScene.instantiate()
		scene.tile_map_node = get_node("../Layer0")
		Scenes.append(scene)
		Scenes[n].Player.ID = n+1
		_onStartDraw(n+1)
		
		
# Add the node as a child of the node the script is attached to.
		add_child(Scenes[n])

	Scenes[0].position = get_node("../Layer0").map_to_local(Vector2 (0,0))
	Scenes[0].Player.location = Vector2(0,0)
	Scenes[0].Player.SpawnLoc = Scenes[0].Player.location
	Scenes[1].position = get_node("../Layer0").map_to_local(Vector2 (7,7))
	Scenes[1].Player.location = Vector2(7,7)
	Scenes[1].Player.SpawnLoc = Scenes[1].Player.location
	DrawArray.shuffle()
	_drawTownDeck()
	
	
	
	order.emit(Turn_Order)
	GlobalScript.DebugScript.add("-------  Player 1's Turn  -----------")
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	#Incremements Turn Order
	Turn_Order = Turn_Order + 1
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	GlobalScript.DebugScript.add("-------  Player "+str(Turn_Order)+"'s Turn  -----------")
	DrawArray.shuffle()
	_drawTownDeck()
	drawcard = false
	order.emit(Turn_Order)
	pass # Replace with function bod
	

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
		#	DrawArray[n] = DrawArray[n+1]
	else:
		for n in 12:
			DrawArray.push_front(DiscardArray[n]) #(dont think this works like I think it does) copy contents from discard back to draw
		DiscardArray.clear()
		DrawArray.shuffle() # shuffles the array contents
		var TDCard = DrawArray[0] #since its and if/else, we need to run the code from the if, or else the player would simply not be able to have a card drawn
		GlobalScript.DebugScript.add("DrawArray drew  "+str(TDCard))
		DrawArray.pop_front()
		DiscardArray.push_front(TDCard)
		GlobalScript.DebugScript.add("DiscardArray has  "+str(DiscardArray))
		GlobalScript.DebugScript.add("DrawArray has  "+str(DrawArray))
		#for n in DrawSize-1:
		#	DrawArray[n] = DrawArray[n+1]
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in numPlayers:
		if (Scenes[n].Player.Health <= 0):
			get_tree().quit()
	pass
	
	
func _on_child_order_changed() -> void:
	pass # Replace with function body

	

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


func _onCardDraw() -> void:
	for HiredGunVar in 3:
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
			if(DistCheck(n) && Scenes[n].Player.Health != 0 && Scenes[Turn_Order-1].Player.ActionPoint !=0):
					# reduces A players health by [1...6]
				var damage = (randi()%6 + 1)
				Scenes[n].Player.Health -= damage
				Attacked = true
				GlobalScript.DebugScript.add("Player "+str(n+1)+" lost "+str(damage)+" points of hp")
				GlobalScript.DebugScript.add("Player "+str(n+1)+" now has "+str(Scenes[n].Player.Health)+" points of hp")
				Scenes[Turn_Order-1].Player.ActionPoint -= 1
				if(Scenes[n].Player.Health <= 0):
					Scenes[n].Player.Health = 0
			elif(Scenes[Turn_Order-1].Player.ActionPoint == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
			elif(!DistCheck(n)):
				GlobalScript.DebugScript.add("Target Not in Range")

func DistCheck(player) -> bool:
	var PlayerLoc = Scenes[Turn_Order-1].Player.location
	var EnemyLoc = Scenes[player].Player.location
	var Dist = Scenes[Turn_Order-1].Player.AttackRange

	
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
		
		for n in numPlayers:
			if(n+1 != Turn_Order):
				if(Scenes[Turn_Order-1].Player.location == Scenes[n].Player.SpawnLoc && Scenes[Turn_Order-1].Player.ActionPoint !=0):
					get_tree().quit()
				elif(Scenes[Turn_Order-1].Player.ActionPoint == 0):
					GlobalScript.DebugScript.add("You have no more Action Points ")
				elif(Scenes[Turn_Order-1].Player.location != Scenes[n].Player.SpawnLoc):
					GlobalScript.DebugScript.add("You are not on a player stable")
		
