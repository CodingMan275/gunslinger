class Character extends CharacterBody2D: 
	const WeaponScript = preload("res://CPU_and_Player/Weapon.gd")
	
	#var ID: int
	var Health : int = 7
	
	var Weapon1Equiped = false
	var Weapon2Equiped = false
	
	var OriginalWeapon
	var OriginalDmg
	var OriginalStun
	var OriginalRange
	
	var Weapon1Name
	var Weapon1Dmg
	var Weapon1Stun
	var Weapon1Range
	
	var Weapon2Name
	var Weapon2Dmg
	var Weapon2Stun
	var Weapon2Range
	
	var GivenWeapon
	var GivenDmg
	var GivenRange
	
	var owning_player: int #assigned
	
	var SpawnLoc : Vector2
	var pos : Vector2
	

	const MAX_ACION_PONTS: int = 1
	
	var ActionPoint = MAX_ACION_PONTS
	var AttackRange: int = 2
	
	var stun_counter: int = 0
	
	var Gun = WeaponScript.Weapon.new()
	var Knife = WeaponScript.Weapon.new()
	
	var has_gun: bool = false
	var has_knife: bool = false
	
	var base_damage: int = 1
	
	var tile_map_node: TileMapLayer
	
	var movable = false
	
	@export var claim_revealed: bool = false
	
	var Player: int
	
	
	
	#Functions
	#_____________________________
	
		# Called when the node enters the scene tree for the first time.
	func _ready() -> void:
		pass # Replace with function body.
	
	func _init(id: int):
		pass
		#ID = id
		
	func can_act() -> bool:
		return ActionPoint > 0
		
	func is_owning_player(player) -> bool:
		return owning_player == player
	
	
	#func can_move(player):
	#	return false
			
	func move_possible() -> bool:
		return tile_map_node.local_to_map(Vector2(get_global_mouse_position())) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) #and tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())) != -1
		
	func can_shoot(player):
		return false
		
	func can_brawl(player) -> bool:
		return false

	func get_pos() -> Vector2:
		return pos
		
	func special_ability(ability) -> void: #takes a lambda that specifies the ability in question
		pass
		
	func character_in_range(char: Character) -> bool:
		return false #create function body later
	'''	
	#takes the player attempting to make the move for reasons that are applicable in later child classes
	func move(player):
		#print("Move: "+str(move_possible()))
		#print(ActionPoint)
		if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0:
			if move_possible():
				self.global_position = Vector2(get_global_mouse_position())
			#	pos = tile_map_node.local_to_map(self.position)
				print(pos)
				movable = false
			#DrawButton.hide()
		elif (Input.is_action_just_pressed("LeftClick") and can_move(player) and ActionPoint == 0):
			GlobalScript.DebugScript.add("You have no more Action Points ")
'''
	func teleport(new_pos: Vector2):
		pos = new_pos
		self.global_position = tile_map_node.map_to_local(new_pos)
		
	func brawl(char: Character, player) -> void:
		if can_brawl(player) and tile_map_node.local_to_map(char.get_pos()) == tile_map_node.local_to_map(pos) and not char.get_is_stunned():
			attack(char)
			char.attack(self)
				
	func attack(char: Character) -> void: #consider adding something for if character is stunned
		if not has_knife:
			char.take_damage(base_damage)
		else:
			char.take_damage(Knife.get_damage())
	
	func shoot(char: Character, player) -> void:
		if can_shoot(player) and character_in_range(char) and not char.get_is_stunned():
			char.take_damage(Gun.get_damage())
			
		
	func become_stunned(stun_time: int) -> void:
		stun_counter = stun_time
		
	func get_is_stunned():
		return stun_counter > 0
		
	func decrement_stun_counter() -> void:
		if stun_counter > 0:
			stun_counter -= 1
		
	func take_damage(damage: int):
		Health -= damage
		
	func get_weapon(weapon) -> void:
		if (weapon.get_is_gun()):
			Gun = weapon
			has_gun = true
		else:
			Knife = weapon
			has_knife = true
			
	#need a function that resets Action Points on Signal from Deck
	func reset_AP_temp():
		ActionPoint = MAX_ACION_PONTS
	



	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(delta: float) -> void:
#Every frame check to see if this node is movable
	#Was left mouse pressed? Enough Action points?
		if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0:
		#See move_possible, see can_move()
			if tile_map_node != null:
				if move_possible() and can_move(Player):
			#Set node's global position to be the positon of the mouse
					self.global_position = Vector2(get_global_mouse_position())
			#Set pos, a variable for storing location, to be the equivelant tile 
					pos = tile_map_node.local_to_map(self.position)
			#Calls the UpdateMove function with the rpc call
					UpdateMove.rpc(self.global_position)
			#Alright we moved, no more
					movable = false
			elif (Input.is_action_just_pressed("LeftClick") and ActionPoint == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")

#See rpc exlaination in Townie_Logic
	@rpc("any_peer")
#Updates the node's postion for every peer
	func UpdateMove(x):
		self.global_position = x
		pos = tile_map_node.local_to_map(self.position)
	
	func can_move(player) -> bool:
	#Are we set to be movable?
		if movable:
		#Have I been claimed?
			if not claim_revealed:
				print("Not claimed")
				return true
			#Ive been claimed, is the person trying to move me the person who owns me?
			elif is_owning_player(player):
				print("I own it")
				return true
			else:
			#Im claimed and the person trying to move me does not own me
				print("I dont own it")
				return false
		else:
		#Im not movable
			print("Movable false")
			return false
	
	
