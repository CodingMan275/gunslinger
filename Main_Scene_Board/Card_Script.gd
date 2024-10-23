extends Node

#Card stuff
@export var HiredGunVar = 3
@export var WeaponCardVar = 5

#Draw and Discard piles that are connected to the multiplayer syncronizer
#These are updated automatically between peers so every peer
#Is looking at the card piles with the same order
#Townie Pile
@export var DrawArray = ["Preacher","Doctor","Teacher","Town_Drunk", "Bar_Keep", "Ranch_Hand"]
@export var DiscardArray = []
#Gunsliger Pile
@export var GunslingerArray = ["Gun1", "Gun2", "Gun3", "Gun4", "Gun5", "Gun6"]
#Hired gun pile
@export var HiredGunArray = ["Preacher","Doctor","Teacher","Town_Drunk","Bar_Keep", "Ranch_Hand"]
#Weapon pile
@export var WeaponArray = ["Rifle1","Rifle2","Rifle3","Rifle4","Knife1","Knife2","Knife3","Knife4","Pistol1","Pistol2","Pistol3","Pistol4","Shotgun1","Shotgun2","Shotgun3","Shotgun4","TwinPistol1","TwinPistol2"]

#Signal for when draw deck is empty and needs to be reshuffled
signal DrawEmpty

#Signal that sends what card was drawn so player can put it in their 
signal DrawnCard

var StartingDraw = false


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
	

#Every peer and the local machine draws from their
#Appropriate deck in their instances
@rpc("any_peer","call_local")
func _drawTownDeck(): # fucntion that simulates the cards being drawn
	var DrawSize = DrawArray.size() # Checks size of the array we're drawing from
	if (DrawSize != 0): # first element exists -> array has some cards left
		var TDCard = DrawArray[0] # gets the first element value
		GlobalScript.DebugScript.add("DrawArray drew  "+str(TDCard))
		DrawArray.pop_front() #pop it out
		DiscardArray.push_front(TDCard) #push on discard array
		#GlobalScript.DebugScript.add("DiscardArray has  "+str(DiscardArray))
		#GlobalScript.DebugScript.add("DrawArray has  "+str(DrawArray))
		#adds card to hand
		DrawnCard.emit(TDCard, false, null)
	else:
		for n in 6:
			DrawArray.push_front(DiscardArray[n]) #(dont think this works like I think it does) copy contents from discard back to draw
		DiscardArray.clear()
		DrawArray.shuffle() # shuffles the array contents
		DrawEmpty.emit()
		var TDCard = DrawArray[0] #since its and if/else, we need to run the code from the if, or else the player would simply not be able to have a card drawn
		DrawArray.pop_front()
		DiscardArray.push_front(TDCard)
		#GlobalScript.DebugScript.add("DiscardArray has  "+str(DiscardArray))
		#GlobalScript.DebugScript.add("DrawArray has  "+str(DrawArray))

@rpc("any_peer","call_local")
func _AddCard(card, player_index):
	GlobalScript.PlayerNode[player_index].PlayerHand.append(card)



func _onStartDraw() -> void:
	# Draw Gunslinger Card
	for player_index in GlobalScript.PlayerNode.size():
		_AddCard.rpc(_draw_card(GunslingerArray, player_index, "Gunslinger"),player_index)

	   #Draw Hired Gun Cards
		for s in range(3):
			StartingDraw = true
			_AddCard.rpc(_draw_card(HiredGunArray, player_index, "Gunslinger"),player_index)
			
		StartingDraw = false
		# Draw Weapon Cards
		for s in range(5):
			_AddCard.rpc(_draw_card(WeaponArray, player_index, "Gunslinger"),player_index)



func _draw_card(array: Array, player_index: int, card_type: String) -> Variant:
	if array.size() == 0:
		GlobalScript.DebugScript.add("No cards left in " + card_type + " array.")
		return null
	var card_index = randi() % array.size()
	var card = array[card_index]
	if(StartingDraw):
		DrawnCard.emit(card, true, player_index)
		print("Sending signal")
	GlobalScript.DebugScript.add.rpc("Player " + str(player_index) + " drew card " + card_type + ": " + card)
	array.erase(card)  # Remove the drawn card
	return card
	
func _ClaimCards(player_index):
	GlobalScript.DebugScript.add(str(GlobalScript.PlayerNode[player_index].PlayerHand))
