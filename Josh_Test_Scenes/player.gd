extends CharacterBody2D 

#Player ID make exportable so it cna be changed
@export var Player_ID = 1
@export var Max_Action_Points = 2
@export var pos : Vector2
@export var Health = 20
#determines the current number of Action Points
@export var action_points = 0
@export var WeaponDmg = 4
@export var WeaponStun = 1
@export var StunTracker = 0

#Player is spawned by rules controller as a child of it
#Getting the parent node which has the emitters we need
@onready var rule_scene = get_parent()
#This more specifically gets the tile map which is then used in later
#movement calcs
@onready var TileMapParent = get_parent().TileMapScene
#Gets the button from the canvas layer where the rules controller is
#This allows for hiding and showing the button unique to each player
@onready var EndTurnLabel = get_parent().EndTurnButton

@onready var DrawButton = get_parent().DrawButton

@onready var AttackButton = get_parent().AttackButton

@onready var HandButton = get_parent().HandButton


#So the player knows what order it is
var order = 0
#determines whether the player can currently move
var can_move = true

#For node path to tile map
var tile_map_node

#Label Name to be used by the PLayer label to keep track of who is who
var LabelName = "TEMP"


var Player = preload("res://CPU_and_Player/PlayerClass.gd").Player.new(0)

#Connect to Rules controller signal when spawned
func _on_ready() -> void:
		#Sets the player instance multiplayer authority to the correct peer
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	#Format Node_Emitter . Signal_From_Emmiter_Node . Connect( Function you want to run in this scene)
	rule_scene.order.connect(_update_turn)
	
	#Gets the current order from the parent scene which is the rules controller
	order = rule_scene.Turn_Order
	
	#Sets the action points the player can use
	action_points = Max_Action_Points
	pass # Replace with function body.

	
	#Update the turn order
func _update_turn(x):
	#This if statement is probably not needed but it just ensures
	#Only the correct peer will be updated when the signal is recieved
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		#Order is updated from the signal sent by the parent class, rules controller
		#Could be rewritten as order = rules_scene.Turn_Order
		order = x
		#If it is NOT the players turn
		if (Player_ID != order):
			#Hide the end turn button so it can not be used
			EndTurnLabel.hide()
			DrawButton.hide()
			AttackButton.hide()
			HandButton.hide()
			#Removes the ability for the player to move
			can_move = false
		else:
			#Set action points back to max
			action_points = Max_Action_Points
			#Allow user to end their turn
			EndTurnLabel.show()
			DrawButton.show()
			AttackButton.show()
			HandButton.show()



	#Movement
func _physics_process(delta):
	MoveMouse()
	
func move_possible():
	#print(tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())))
	return tile_map_node.local_to_map(Vector2(get_global_mouse_position())) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) #and tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())) != -1

func MoveMouse():
	#Another if statement that is probably not needed but ensures that only the peer
	#who owns this player instance can move it
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if(Player_ID == order && GlobalScript.PlayerNode[order-1].StunTracker == 0):
			if Input.is_action_just_pressed("LeftClick") and can_move and action_points > 0:
				if  move_possible():
					self.global_position = Vector2(get_global_mouse_position())
					pos = tile_map_node.local_to_map(self.position)
					print(pos)
					action_points -= 1
			elif (Input.is_action_just_pressed("LeftClick") and move_possible() and action_points == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
			if (!can_move):
				can_move = true
		elif(Input.is_action_just_pressed("LeftClick") and GlobalScript.PlayerNode[order-1].StunTracker != 0):
			GlobalScript.DebugScript.add("Player is stunned you cannot move")
