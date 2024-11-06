extends "res://CPU_and_Player/Character.gd".Character
class_name Townsfolk

var is_hired_gun: bool = false
var townsfolk_list: Array = []
var incapacitated_turns: int = 0  # Track remaining turns of incapacity

# Healing tracking
var healing_counts: Dictionary = {}  # Track how many times each character has been healed
var purchased_weapons: Dictionary = {}  # Track purchased weapons for each player

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	townsfolk_list = []  # Initialize the townsfolk list

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if incapacitated_turns > 0:
		incapacitated_turns -= 1  # Decrement turns if incapacitated

	# Handle waiting for purchased weapons
	for player in [1, 2]:  # Assuming there are two players
		if purchased_weapons.has(player):
			purchased_weapons[player].turns_to_wait -= 1
			if purchased_weapons[player].turns_to_wait <= 0:
				purchased_weapons[player].is_ready_to_use = true

func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_specialAbilitiesButton_pressed()

func hire_townsfolk(player: int) -> void:
	owning_player = player
	is_hired_gun = true

func reveal_hired_gun() -> void:
	claim_revealed = true

func can_shoot(player) -> bool:
	return claim_revealed and is_owning_player(player) and has_gun and not get_is_stunned() and incapacitated_turns == 0 and purchased_weapons[player].is_ready_to_use

func can_brawl(player) -> bool:
	return claim_revealed and is_owning_player(player) and not get_is_stunned() and incapacitated_turns == 0

func can_move(player) -> bool:
	return not claim_revealed or is_owning_player(player) and incapacitated_turns == 0

func _on_specialAbilitiesButton_pressed() -> void:
	for townsfolk in townsfolk_list:
		activate_special_abilities(townsfolk)

func activate_special_abilities(townsfolk: Townsfolk) -> void:
	if townsfolk.is_hired_gun and not townsfolk.claim_revealed:
		townsfolk.reveal_hired_gun()
		print("Revealed hired gun ability for: ", townsfolk)
		
		if townsfolk.can_shoot(owning_player):
			print("Townsfolk can shoot!")
		
		if townsfolk.can_brawl(owning_player):
			print("Townsfolk can brawl!")
		
		if townsfolk.can_move(owning_player):
			print("Townsfolk can move!")

		# Specific behavior for the storekeeper
		if townsfolk.is_storekeeper(): 
			sell_weapon(townsfolk, owning_player)

func sell_weapon(storekeeper: Townsfolk, player: int) -> void:

	var weapon = "Pistol"  # Example weapon
	print("Selling ", weapon, " to Player ", player)

	# Initialize or update the purchased weapons dictionary for the player
	if not purchased_weapons.has(player):
		purchased_weapons[player] = { "turns_to_wait": 1, "is_ready_to_use": false }
	
	# Mark the weapon as purchased
	purchased_weapons[player].is_ready_to_use = false
	purchased_weapons[player].turns_to_wait = 1  # Set to wait one turn before using

	print("Player ", player, " has purchased a ", weapon, ". Must wait ", purchased_weapons[player].turns_to_wait, " turn(s) to use it.")

func get_characters_in_same_space(position: Vector2) -> Array:
	var characters: Array = []
	for townsfolk in townsfolk_list:
		if townsfolk.position == position:  # Check if the townsfolk is in the same position
			characters.append(townsfolk)
	return characters

func heal(character: Townsfolk) -> void:
	# Logic to heal the character by 1 wound
	character.wounds -= 1  # Assuming there is a wounds property on the character
	if character.wounds < 0:
		character.wounds = 0  # Prevent negative wounds
	print(character, " has been healed. Remaining wounds: ", character.wounds)

	
