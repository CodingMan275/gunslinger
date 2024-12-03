class Character extends CharacterBody2D: 
	const WeaponScript = preload("res://CPU_and_Player/Weapon.gd")
	
	var rules 
	
	var cards
	
	
	var is_gunslinger = false
	
	var is_dead = false
	
	#var ID: int
	var Name : String
	var Health : int = 7
	
	var Weapon1Equiped = false
	var Weapon2Equiped = false
	
	var proficiency
	var DrewCard = false
	
	var OriginalWeapon
	var OriginalDmg
	var OriginalStun
	var OriginalRange
	
	var Weapon1Name = ""
	var Weapon1Dmg = 4
	var Weapon1Stun = 1
	var Weapon1Range = 2
	
	var Weapon2Name = ""
	var Weapon2Dmg = 0
	var Weapon2Stun = 0
	var Weapon2Range = 0
	
	var GivenWeapon
	var GivenDmg
	var GivenRange
	
	var owning_player: int #assigned
	
	@export var RandSpawnLoc : Array
	var SpawnLoc : Vector2
	var pos : Vector2
	

	const MAX_ACION_PONTS: int = 1
	
	var action_points = MAX_ACION_PONTS
	var AttackRange: int = 2
	
	var StunTracker: int = 0
	
	var Gun = WeaponScript.Weapon.new()
	var Knife = WeaponScript.Weapon.new()
	
	var has_gun: bool = false
	var has_knife: bool = false
	
	var base_damage: int = 1
	
	var tile_map_node: TileMapLayer
	var highlight_node: TileMapLayer
	
	var movable = false
	
	@export var claim_revealed: bool = false
	
	var Player: int
	
	var CanDynamite : bool = false
	
	
	
	#Functions
	#_____________________________
	
		# Called when the node enters the scene tree for the first time.
	func _ready() -> void:
		pass # Replace with function body.
	
	func _init(id: int):
		pass
		#ID = id
		
	func can_act() -> bool:
		return action_points > 0
		
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
	@rpc("any_peer","call_local")
	func HealthCheck():
		if Health <= 0:
			if cards.DrawArray.has(rules.Target.name):
				for i in cards.DrawArray.size() - 1:
					if cards.DrawArray[i] == rules.Target.name:
						cards.DrawArray.pop_at(i)
			elif cards.DiscardArray.has(rules.Target.name):
				for i in cards.DiscardArray.size() - 1:
					if cards.DiscardArray[i] == rules.Target.name:
						cards.DiscardArray.pop_at(i)
			self.pos = Vector2(13,13)
			is_dead = true
			self.hide()
			print("I'm dead")
		else:
			pass
	
	
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
		StunTracker = stun_time
		
	func get_is_stunned():
		return StunTracker > 0
		
	func decrement_stun_counter() -> void:
		if StunTracker > 0:
			StunTracker -= 1
		
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
		action_points = MAX_ACION_PONTS
	



	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(delta: float) -> void:
	#Every frame check to see if this node is movable
	#Was left mouse pressed? Enough Action points?
		if Input.is_action_just_pressed("LeftClick") and action_points > 0:
		#See move_possible, see can_move()
			if tile_map_node != null:
				var NewPos = tile_map_node.local_to_map(Vector2(get_global_mouse_position()))
				if move_possible() and can_move(Player):# and movable:
					if TileCheck(NewPos):
						#Set node's global position to be the positon of the mouse
						self.global_position = Vector2(get_global_mouse_position())
						#Set pos, a variable for storing location, to be the equivelant tile 
						pos = tile_map_node.local_to_map(self.position)
						action_points -= 1
						#Calls the UpdateMove function with the rpc call
						UpdateMove.rpc(self.global_position)
						#Alright we moved, no more
						movable = false
						#hide_possible_moves()
			elif (Input.is_action_just_pressed("LeftClick") and action_points == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
				#hide_possible_moves()




	func TileCheck(Mouse) -> bool:
		var Ppos = pos
		
		#Cannot move to a null space
		if tile_map_node.get_cell_atlas_coords(Mouse) == Vector2i(-1, -1):
			return false
		#Cannot move into stable , Bank , Church , School from a path
		elif tile_map_node.Path(Ppos) && (tile_map_node.Stable(Mouse) || tile_map_node.WalledBuilding(Mouse)) :
			return false
		#Cannot move from a special building to a path
		elif tile_map_node.WalledBuilding(Ppos) && tile_map_node.Path(Mouse):
			return false
		#Can only go from jail to sherrif
		elif tile_map_node.Jail(Ppos) && !tile_map_node.Building(Mouse):
			return false
		#Can not move to jail
		elif tile_map_node.Jail(Mouse):
			return false
		else:
			return true
		return true
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
	
	'''func show_possible_moves(pos):
		for tile in tile_map_node.get_surrounding_cells(pos):
			if TileCheck(tile):
				highlight_node.set_cell(tile, 16, Vector2i(0,0))
	
	func hide_possible_moves():
		highlight_node.clear()'''
