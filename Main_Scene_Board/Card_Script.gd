extends Node

#Card stuff
@export var HiredGunVar = 3
@export var WeaponCardVar = 5

@onready var draw_card1: AudioStreamPlayer2D = $"../CanvasLayer/Draw Card/DrawCardSFX"
@onready var CardUI = get_node("../Townie_Logic")

#Draw and Discard piles that are connected to the multiplayer syncronizer
#These are updated automatically between peers so every peer
#Is looking at the card piles with the same order
#Townie Pile
@export var DrawArray = ["Preacher","Doctor","Teacher","Town_Drunk", "Bar_Keep", "Ranch_Hand", "Sheriff", "Bank_Manager", "Bounty_Hunter", "Store_Keeper", "Mountain_Man", "Saloon_Girl"]
@export var DiscardArray = []
#Gunsliger Pile

@export var GunslingerArray = ["Bob", "Mad_Mike", "Jon_Laramie", "Elijah", "Smokey", "The_Kidd"]
#Hired gun pile
@export var HiredGunArray = ["Preacher","Teacher","Town_Drunk","Bar_Keep", "Ranch_Hand", "Bounty_Hunter", "Mountain_Man", "Saloon_Girl"]
#Weapon pile
@export var WeaponArray = ["Rifle","Rifle","Rifle","Rifle","Knife","Knife","Knife","Knife","Pistol","Pistol","Pistol","Pistol","Shotgun","Shotgun","Shotgun","Shotgun","TwinPistol","TwinPistol", "TwinPistol", "TwinPistol"]

#Signal for when draw deck is empty and needs to be reshuffled
signal DrawEmpty

#Signal that sends what card was drawn so player can put it in their 
signal DrawnCard

signal StartDrawOver

var StartingDraw = false

var CardPos : Vector2 #hey
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#This is called to shuffle the the Townie pile
	#Becuase there are multiple "Cards" scenes, as many as there are
	#peers this will get called multiple times which means it will get shuffled
	#for however many times there are peers.
	#This is not a bad thing becuase the multiplayer syncronizer will still
	#Keeps the piles synced in the end, every peer looks at identical piles
	DrawArray.shuffle()
	
	pass # Replace with function body.
	
func _onCardDraw() -> void:
	#Draws from the townie deck, rpc to do rpc functions
	_drawTownDeck.rpc()
	
	CardUI.ShowAttackUICheck()

#Every peer and the local machine draws from their
#Appropriate deck in their instances
@rpc("any_peer","call_local")
func _drawTownDeck(): # fucntion that simulates the cards being drawn
	var draw_card: AudioStreamPlayer2D = $"../CanvasLayer/Draw Card/DrawCardSFX"
	draw_card.play()
	var DrawSize = DrawArray.size() # Checks size of the array we're drawing from
	if (DrawSize == 0): # first element exists -> array has some cards left
		for n in 12  :
			DrawArray.push_front(DiscardArray[n]) #(dont think this works like I think it does) copy contents from discard back to draw
		DiscardArray.clear()
		if multiplayer.is_server():
			DrawArray.shuffle() # shuffles the array contents
			shuffle.rpc(DrawArray)
		var shuffle_sound: AudioStreamPlayer2D = $"../CanvasLayer/Draw Card/ShuffleSoundFX"
		shuffle_sound.play() #should play when decks reshuffled
		DrawEmpty.emit()
		var TDCard = DrawArray[0] #since its and if/else, we need to run the code from the if, or else the player would simply not be able to have a card drawn
		DrawArray.pop_front()
		DiscardArray.push_front(TDCard)
	var TDCard = DrawArray[0] # gets the first element value
	DrawArray.pop_front() #pop it out
	DiscardArray.push_front(TDCard) #push on discard array
	#adds card to hand
	DrawnCard.emit(TDCard, false, null)
	
@rpc("any_peer")
func shuffle(X):
	{
		DrawArray = X
	}

@rpc("any_peer","call_local")
func _AddCard(card, player_index, g):
	GlobalScript.PlayerNode[player_index].PlayerHand.append(card)
	if g == "g":
		var GunSlingerNode = load("res://Main_Scene_Board/Gunslingers/"+card+".tscn")
		var instance = GunSlingerNode.instantiate()
		GlobalScript.PlayerNode[player_index].add_child(instance)
	



func _onStartDraw() -> void:
	# Draw Gunslinger Card
	for player_index in GlobalScript.PlayerNode.size():
		_AddCard.rpc(_draw_card(GunslingerArray, player_index, "Gunslinger"),player_index, "g")

	   #Draw Hired Gun Cards
		for s in range(3):
			StartingDraw = true
			_AddCard.rpc(_draw_card(HiredGunArray, player_index, "Gunslinger"),player_index, null)
			
		StartingDraw = false
		# Draw Weapon Cards
		for s in range(5):
			_AddCard.rpc(_draw_card(WeaponArray, player_index, "Gunslinger"),player_index, null)
	SDO.rpc()

@rpc("call_local","any_peer")
func SDO():
	StartDrawOver.emit()
	pass


func _draw_card(array: Array, player_index: int, card_type: String) -> Variant:
	if array.size() == 0:
		return null
	var card_index = randi() % array.size()
	var card = array[card_index]
	DrawnCard.emit(card, true, player_index)
	#GlobalScript.DebugScript.add.rpc("Player " + str(player_index) + " drew card " + card_type + ": " + card)
	
	array.erase(card)  # Remove the drawn card
	return card
	
func _ClaimCards(player_index):
	GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[player_index].PlayerHand))
	
	

#Gets and sets card art
func CardArt(CardName):
	if(CardName == "Preacher"):
		return("res://Main_Scene_Board/Townsfolk/The Preacher character card.png")
	elif(CardName == "Doctor"):
		return("res://Main_Scene_Board/Townsfolk/the doctor character card.png")
	elif(CardName == "Teacher"):
		return("res://Main_Scene_Board/Townsfolk/The_teacher_character card.png")
	elif(CardName == "Town_Drunk"):
		return("res://Main_Scene_Board/Townsfolk/town drunk character card.png")
	elif(CardName == "Bar_Keep"):
		return("res://Main_Scene_Board/Townsfolk/barkeep character card.png")
	elif(CardName == "Ranch_Hand"):
		return("res://Main_Scene_Board/Townsfolk/ranch hand character card.png")
	elif(CardName == "Sheriff"):
		return("res://Main_Scene_Board/Townsfolk/the sherrif character card.png")
	elif(CardName == "Saloon_Girl"):
		return("res://Main_Scene_Board/Townsfolk/Saloon girl character card.png")
	elif(CardName == "Mountain_Man"):
		return("res://Main_Scene_Board/Townsfolk/Mountain_Man_character card.png")
	elif(CardName == "Store_Keeper"):
		return("res://Main_Scene_Board/Townsfolk/General_Store_Keeper_character card.png")
	elif(CardName == "Bank_Manager"):
		return("res://Main_Scene_Board/Townsfolk/Bank manager character card.png")
	elif(CardName == "Bounty_Hunter"):
		return("res://Main_Scene_Board/Townsfolk/Bounty hunter character card.png")
	elif(CardName == "Knife"):
		return("res://Main_Scene_Board/Weapon_Art/Knife weapon card.png")
	elif(CardName == "Pistol"):
		return("res://Main_Scene_Board/Weapon_Art/Pistol weapon card.png")
	elif(CardName == "TwinPistol"):
		return("res://Main_Scene_Board/Weapon_Art/Twin Pistol weapon card.png")
	elif(CardName == "Rifle"):
		return("res://Main_Scene_Board/Weapon_Art/Rifle weapon card.png")
	elif(CardName == "Shotgun"):
		return("res://Main_Scene_Board/Weapon_Art/Shotgun weapon card.png")
	else:
		return("res://icon.svg")
	pass
	
###################################
###################################
###################################
"""
	2. Each one of those nodes, needs to implement the following three functions
   a. get_save_id() : returns a unique id for this node as a string.
	  Apparently, Godot does not have UUIDs, so we have to make our own.
"""
func get_save_id():
	return "cards"

"""
   b. save(): this methods returns a dictionary with the data that node
	  needs to save/restore during gameplay.
	  Here is an example from an unrelated game
"""
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"HiredGunVar" : HiredGunVar,
		"WeaponCardVar" : WeaponCardVar,
		"DrawArray" : DrawArray,
		"DiscardArray" : DiscardArray,
		"GunslingerArray" : GunslingerArray,
		"HiredGunArray"	: HiredGunArray,
		"WeaponArray" : WeaponArray,
		"StartingDraw" : StartingDraw,
		"CardPos.x" : CardPos.x,		
		"CardPos.y" : CardPos.y
	}
	return save_dict


"""
	c. restore(saved_data): this method gets a dictionary of previously saved data
	   and uses it to restore the state of the node. This is the same dictonary
	   structure returned by save().
"""
func restore(saved_data):
	HiredGunVar =saved_data["HiredGunVar"]
	WeaponCardVar =saved_data["WeaponCardVar"]
	DrawArray =saved_data["DrawArray"]
	DiscardArray =saved_data["DiscardArray"]
	GunslingerArray =saved_data["GunslingerArray"]
	HiredGunArray =saved_data["HiredGunArray"]
	WeaponArray =saved_data["WeaponArray"]
	StartingDraw =saved_data["StartingDraw"]
	CardPos.x =saved_data["CardPos.x"]
	CardPos.y =saved_data["CardPos.y"]
	pass
