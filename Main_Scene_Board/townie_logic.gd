extends Node


#This gets refrences to the children nodes which we know
#for a fact are going to be named after the twonies / hired guns
#becuase we are naming each node properly
@onready var Preacher = get_node("Preacher")
@onready var Teacher = get_node("Teacher")
@onready var Doctor = get_node("Doctor")
@onready var Town_Drunk = get_node("Town_Drunk")
@onready var Bar_Keep = get_node("Bar_Keep")
@onready var Ranch_Hand = get_node("Ranch_Hand")
@onready var Store_Keeper = get_node("Store_Keeper")
@onready var Mountain_Man = get_node("Mountain_Man")
@onready var Bounty_Hunter = get_node("Bounty_Hunter")
@onready var Saloon_Girl = get_node("Saloon_Girl")
@onready var Bank_Manager = get_node("Bank_Manager")
@onready var Sheriff = get_node("Sheriff")

#Getting a refrence to the card deck and the rules controller
@onready var CardDecks = get_node("../Cards")
@onready var Rules = get_node("../Rules_Controller")

#This empty variable will be filled with which card was most recently drawn
#This will be helpful for telling which townie to move
var CurrentCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Preacher.position = get_node("../Player_Layer").map_to_local(Vector2 (5,5))
	Teacher.position = get_node("../Player_Layer").map_to_local(Vector2 (6,3))
	Doctor.position = get_node("../Player_Layer").map_to_local(Vector2 (1,6))
	Town_Drunk.position = get_node("../Player_Layer").map_to_local(Vector2 (5,4))
	Bar_Keep.position = get_node("../Player_Layer").map_to_local(Vector2 (7,0))
	Ranch_Hand.position = get_node("../Player_Layer").map_to_local(Vector2 (6,4))
	Sheriff.position = get_node("../Player_Layer").map_to_local(Vector2(4,3))
	Store_Keeper.position = get_node("../Player_Layer").map_to_local(Vector2(4,0))
	Mountain_Man.position = get_node("../Player_Layer").map_to_local(Vector2(2,2))
	Bounty_Hunter.position = get_node("../Player_Layer").map_to_local(Vector2(1,5))
	Saloon_Girl.position = get_node("../Player_Layer").map_to_local(Vector2(2,5))
	Bank_Manager.position = get_node("../Player_Layer").map_to_local(Vector2(5,2))
	Preacher.pos = get_node("../Player_Layer").local_to_map(Preacher.position)
	Teacher.pos = get_node("../Player_Layer").local_to_map(Teacher.position)
	Doctor.pos = get_node("../Player_Layer").local_to_map(Doctor.position)
	Town_Drunk.pos = get_node("../Player_Layer").local_to_map(Town_Drunk.position)
	Bar_Keep.pos = get_node("../Player_Layer").local_to_map(Bar_Keep.position)
	Ranch_Hand.pos = get_node("../Player_Layer").local_to_map(Ranch_Hand.position)
	Sheriff.pos = get_node("../Player_Layer").local_to_map(Sheriff.position)
	Store_Keeper.pos = get_node("../Player_Layer").local_to_map(Store_Keeper.position)
	Mountain_Man.pos = get_node("../Player_Layer").local_to_map(Mountain_Man.position)
	Bounty_Hunter.pos = get_node("../Player_Layer").local_to_map(Bounty_Hunter.position)
	Saloon_Girl.pos = get_node("../Player_Layer").local_to_map(Saloon_Girl.position)
	Bank_Manager.pos = get_node("../Player_Layer").local_to_map(Bank_Manager.position)
	
	Preacher.tile_map_node = get_node("../Player_Layer")
	Teacher.tile_map_node = get_node("../Player_Layer")
	Doctor.tile_map_node = get_node("../Player_Layer")
	Town_Drunk.tile_map_node = get_node("../Player_Layer")
	Bar_Keep.tile_map_node = get_node("../Player_Layer")
	Ranch_Hand.tile_map_node = get_node("../Player_Layer")
	Store_Keeper.tile_map_node = get_node("../Player_Layer")
	Mountain_Man.tile_map_node = get_node("../Player_Layer")
	Bounty_Hunter.tile_map_node = get_node("../Player_Layer")
	Saloon_Girl.tile_map_node = get_node("../Player_Layer")
	Bank_Manager.tile_map_node = get_node("../Player_Layer")
	Sheriff.tile_map_node = get_node("../Player_Layer")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#This function is directly connected to the signal emited from the Cards node
#We do not need NodeRef.Signal.connect(Function) because these two scripts are in the
#same scene before run time, so if you click on the node on the right side of the screen
#and open the "Node" tab in the inspector area you can see which signals are conencted
#to which functions in the same scene
func UpdateCard(x,y,z):
	#Y is the boolean of "FirstDraw", becuase we use the same signal for both the
	#starting hand and drawing additional cards throughout the game
	#If y is false, go aka if not the first draw go
	if(!y):
		#Set CurrentCard to x, x being the string og the current drawn card
		#Which will be a name of a townie
		CurrentCard = x
		$"../CanvasLayer/CurrentTownie".texture =ResourceLoader.load($"../Cards".CardArt(CurrentCard))
		$"../CanvasLayer/CurrentTownie".show()
	pass

#Function and signal connecting same as UodateCard, this time it is triggered
#When the button from the canvas layer is pressed
func _on_claim_pressed() -> void:
	#Get the node with the name of the current card, then when we have that node use the
	#the function reveal_hired_gun(). Note this will only work and NOT crash if the Node both exists and has
	#The funciton call
	get_node(CurrentCard).reveal_hired_gun()
	#Set movable to be true
	get_node(CurrentCard).movable = true
	get_node(CurrentCard).get_child(2).visible = true
	HideSpecialAbility.rpc()
	Rules.get_node(str(multiplayer.get_unique_id())).NearbyTownieCheck()
	#Each hird gun will have a variable for which PLayer currently has control over it,
	#We want to assign this variable to the player ID that clciked the button
	#To do this we need to use the built in Multiplayer API from Godot,
	#We use this API's function .get_unique_id(), this will the get the user's current Godot assigned multiplayer ID
	#From there we convert that INT to a String, now we take that string and will serach all of the
	#Rules Controller's children that have the same name, we know for a fact we named the ucrrent player's
	#node the same as their unique id, from there we take the Player_ID we assinged it and then
	#Set the variable inside the hired gun to be the same INT
	if(GlobalScript.SinglePlay):
		get_node(CurrentCard).Player = Rules.get_node("player").Player_ID
	else:
		get_node(CurrentCard).Player = Rules.get_node(str(multiplayer.get_unique_id())).Player_ID
	#Calls the function and makes sure it uses the RPC properties
	#Function() =\= Function.rpc()
	SchizoFunctionPleaseWork.rpc()
	pass # Replace with function body.

#Any Peer means that every peer EXCEPT the machine that sent out the rpc call
#will run the function
@rpc("any_peer")
#So the logic here is that only the person who can claim the hired gun and does so
#Will send the hired gun all the correct information for it to work,
#which in a sense means everyone else should send it information that makes it no longer work
func SchizoFunctionPleaseWork():
	#Make sure everyone knows its revealed
	get_node(CurrentCard).reveal_hired_gun()
	#Make it unmovable for everyone else 
	get_node(CurrentCard).movable = false
	#Just to be sure tell it that the current player is 0, and there is no player 0
	#Meaning it will never run
	get_node(CurrentCard).Player = 0
	#Keep in mind this is ONLY for everyone else who never even had the abiltiy
	#To claim this hired gun and once its claimed it does not matter if these values
	#are wrong becuase once it is claimed it will never ben controlled by anyone else again
	pass


func ShowAttackUICheck():
	if CurrentCard != null:
		var thing = get_node(CurrentCard)
		if ((thing.OwningPlayer == GlobalScript.PlayerNode[Rules.Turn_Order-1].Player_ID) and (thing.claim_revealed == false)):
			thing.get_child(1).visible = true
		elif((thing.OwningPlayer == GlobalScript.PlayerNode[Rules.Turn_Order-1].Player_ID) and (thing.claim_revealed == true)):
			thing.get_child(2).visible = true
		else:
			thing.get_child(1).visible = true

func _on_button_pressed() -> void:
	if CurrentCard != null:
		HideAttackUI.rpc()
	pass # Replace with function body.
@rpc("any_peer","call_local")
func HideAttackUI() -> void:
	get_node(CurrentCard).get_child(1).visible = false
	get_node(CurrentCard).get_child(2).visible = false
@rpc("any_peer","call_local")
func HideSpecialAbility():
	get_node(CurrentCard).get_child(1).visible = false
