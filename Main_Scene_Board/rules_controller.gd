extends Node

@export var Turn_Order = 1

signal order

@export var numPlayers = 2

var Scenes : Array
var drawcard : bool = false
var PlayerScene = preload("res://Josh_Test_Scenes/Player.tscn")

var HiredGunVar = 3
var WeaponCardVar = 5


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
	
	
	
	order.emit(Turn_Order)
	GlobalScript.DebugScript.add("-------  Player 1's Turn  -----------")
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	#Incremements Turn Order
	Turn_Order = Turn_Order + 1
	if Turn_Order == numPlayers+1:
		Turn_Order = 1
	GlobalScript.DebugScript.add("-------  Player "+str(Turn_Order)+"'s Turn  -----------")
	drawcard = false
	order.emit(Turn_Order)
	pass # Replace with function bod
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in numPlayers:
		if (Scenes[n].Player.Health <= 0):
			get_tree().quit()
	pass
	
	
func _on_child_order_changed() -> void:
	pass # Replace with function body

	

func _onStartDraw(n) -> void:
	
	for HiredGunVar in 3:
		var CardNum = randi()%52+1
		GlobalScript.DebugScript.add("Player "+str(n)+" drew card "+str(CardNum))
		Scenes[n-1].Player.add_card(CardNum)
		

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
		
