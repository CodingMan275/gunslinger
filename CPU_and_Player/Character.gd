class Character extends CharacterBody2D: 
	const WeaponScript = preload("res://CPU_and_Player/Weapon.gd")
	
	#var ID: int
	var Health : int = 7
	
	var SpawnLoc : Vector2
	var pos : Vector2

	const MAX_ACION_PONTS: int = 1
	
	var ActionPoint = MAX_ACION_PONTS
	var AttackRange: int = 2
	
	var is_stunned: bool = false
	
	var Gun = WeaponScript.Weapon.new()
	var Knife = WeaponScript.Weapon.new()
	
	var has_gun: bool = false
	var has_knife: bool = false
	
	var base_damage: int = 1
	
	var tile_map_node: TileMapLayer
	
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
		
	func can_move():
		return tile_map_node.local_to_map(Vector2(get_global_mouse_position())) in tile_map_node.get_surrounding_cells(tile_map_node.local_to_map(self.global_position)) and tile_map_node.get_cell_source_id(Vector2(get_global_mouse_position())) != -1
			
	func can_shoot(char: Character) -> bool:
		return false
		
	func can_brawl() -> bool:
		return false

	func get_pos() -> Vector2:
		return pos
		
	func special_ability() -> void:
		pass
		
	func move():
		if Input.is_action_just_pressed("LeftClick") and ActionPoint > 0:
			if  can_move():
				self.global_position = Vector2(get_global_mouse_position())
				pos = tile_map_node.local_to_map(self.position)
				print(pos)
				#DrawButton.hide()
			elif (Input.is_action_just_pressed("LeftClick") and can_move() and ActionPoint == 0):
				GlobalScript.DebugScript.add("You have no more Action Points ")
		
	func brawl(char: Character) -> void:
		if can_brawl() and tile_map_node.local_to_map(char.get_pos()) == tile_map_node.local_to_map(pos):
			attack(char)
			char.attack(self)
				
	func attack(char: Character) -> void:
		if not has_knife:
			char.take_damage(base_damage)
		else:
			char.take_damage(Knife.get_damage())
	
	func shoot(char: Character) -> void:
		if can_shoot(char):
			char.take_damage(Gun.get_damage())
			
		
	func become_stunned():
		is_stunned = true
		
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
		pass
