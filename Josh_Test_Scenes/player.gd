extends CharacterBody2D 


#Player ID make exportable so it cna be changed
#@export var Player_ID = 1

#Player is spawned by rules controller as a child of it
#Getting the parent node which has the emitters we need
@onready var rule_scene = get_parent()

#So the player knows what order it is
var order = 0
#determines whether the player can currently move
var can_move = true

#For node path to tile map
var tile_map_node

var DrawArray = ["Td1","Td2","Td3"]
var DiscardArray = []

var Player = preload("res://CPU_and_Player/PlayerClass.gd").Player.new(0)

#Connect to Rules controller signal when spawned
func _on_ready() -> void:
	#Format Node_Emitter . Signal_From_Emmiter_Node . Connect( Function you want to run in this scene)
	rule_scene.order.connect(_update_turn)
	pass # Replace with function body.
	
	#Update the turn order
func _drawTownDeck(): # fucntion that simulates the cards being drawn
	# 
	var DrawSize = DrawArray.size() # Checks size of the array we're drawing from
	if (DrawArray[0] != null): # first element exists -> array has some cards left
		var TDCard = DrawArray[0] # gets the first element value
		GlobalScript.DebugScript.add("DrawArray drew  "+str(TDCard))
		DrawArray.pop_front() #pop it out
		DiscardArray.push_front(TDCard) #push on discard array
		for n in DrawSize-1: # (in theory) should loop through the array and "push" everything up one spot in the array
			DrawArray[n] = DrawArray[n+1]
	else:
		DrawArray = DiscardArray #(dont think this works like I think it does) copy contents from discard back to draw
		DrawArray.shuffle() # shuffles the array contents
		var TDCard = DrawArray[0] #since its and if/else, we need to run the code from the if, or else the player would simply not be able to have a card drawn
		GlobalScript.DebugScript.add("DrawArray drew  "+str(TDCard))
		DrawArray.pop_front()
		DiscardArray.push_front(TDCard)
		for n in DrawSize-1:
			DrawArray[n] = DrawArray[n+1]
		
	

func _update_turn(x):
	order = x
	if (Player.ID != order):
		can_move = false
	else:
		Player.ActionPoint = 2
	#Movement
func _physics_process(delta):
	MoveMouse()
	
func move_possible():
	#print(tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())))
	return tile_map_node.local_to_map(Vector2(get_global_mouse_position())) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) #and tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())) != -1

func MoveMouse():
	if(Player.ID == order):
		if Input.is_action_just_pressed("LeftClick") and can_move and Player.ActionPoint > 0:
			if  move_possible():
				self.global_position = Vector2(get_global_mouse_position())
				Player.location = tile_map_node.local_to_map(self.global_position)
			#	print(tile_map_node.local_to_map(self.global_position))
				Player.ActionPoint -= 1
		elif (Input.is_action_just_pressed("LeftClick") and move_possible() and Player.ActionPoint == 0):
			GlobalScript.DebugScript.add("You have no more Action Points ")
		if (!can_move):
			can_move = true
