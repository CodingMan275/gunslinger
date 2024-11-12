extends "res://CPU_and_Player/Character.gd".Character
class_name Townsfolk

var is_hired_gun: bool = false
var townsfolk_list: Array = []
var incapacitated_turns: int = 0  # Track remaining turns of incapacity

# Healing tracking
var healing_counts: Dictionary = {}  # Track how many times each character has been healed
var purchased_weapons: Dictionary = {}  # Track purchased weapons for each player
var drawn_card: Townsfolk  # To store the last drawn card

# Reference to the Special Abilities button
onready var special_abilities_button = $SpecialAbilitiesButton

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_townsfolk()  # Populate the townsfolk list
	drawn_card = null  # Initialize the drawn card variable
	special_abilities_button.hide()  # Hide the special abilities button initially

func initialize_townsfolk() -> void:
	# Initialize townsfolk instances
	townsfolk_list.append(Preacher.new())
	townsfolk_list.append(Teacher.new())
	townsfolk_list.append(Doctor.new())
	townsfolk_list.append(TownDrunk.new())
	townsfolk_list.append(BarKeep.new())
	townsfolk_list.append(RanchHand.new())
	townsfolk_list.append(StoreKeeper.new())
	townsfolk_list.append(MountainMan.new())
	townsfolk_list.append(BountyHunter.new())
	townsfolk_list.append(SaloonGirl.new())
	townsfolk_list.append(BankManager.new())
	townsfolk_list.append(Sheriff.new())

# Function to handle drawing a card from the draw deck
func draw_card_from_card(player: int, draw_deck: Draw card) -> void:
	drawn_card = draw_deck.draw_card()  # Assume draw_card() returns a Townsfolk instance
	if drawn_card:
		print("Player ", player, " drew a card: ", drawn_card.name)

		# Show the special abilities button if conditions are met
		if drawn_card.is_hired_gun and not drawn_card.claim_revealed:
			drawn_card.reveal_hired_gun()

		# Show the special abilities button after drawing a card
		special_abilities_button.show()

		# Activate abilities if conditions are met
		activate_special_abilities(drawn_card, player)

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

func activate_special_abilities(townsfolk: Townsfolk, player: int) -> void:
	if townsfolk.can_shoot(player):
		print(townsfolk.name, " can shoot!")
		# Add logic to perform shooting action here

	if townsfolk.can_brawl(player):
		if townsfolk is Teacher:
			townsfolk.activate_special_ability()  # Activate the Teacher's Derringer Special
		else:
			print(townsfolk.name, " can brawl!")
			# Add logic for other townsfolk's brawling action here

	if townsfolk.can_move(player):
		print(townsfolk.name, " can move!")
		# Add logic for moving action here

	# Call specific abilities based on the townsfolk type
	match townsfolk.name:
		"Doctor":
			heal(townsfolk)  # Example of healing action
		"Preacher":
			townsfolk.pacify()  # Preacher's ability
		"Town Drunk":
			townsfolk.cause_ruckus()  # Town Drunk's ability
		"Bar Keep":
			townsfolk.puppy_love()  # Bar Keep's ability
		"Ranch Hand":
			townsfolk.help_with_ranching()  # Ranch Hand's ability
		"Store Keeper":
			sell_weapon(townsfolk, player)  # Store Keeper's ability to sell weapons
		"Mountain Man":
			townsfolk.track()  # Mountain Man's ability
		"Bounty Hunter":
			townsfolk.capture()  # Bounty Hunter's ability
		"Saloon Girl":
			townsfolk.entertain()  # Saloon Girl's ability
		"Bank Manager":
			townsfolk.manage_funds()  # Bank Manager's ability
		"Sheriff":
			townsfolk.enforce_law()  # Sheriff's ability

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
	character.wounds -= 1  # Assuming there is a wounds property on the character
	if character.wounds < 0:
		character.wounds = 0  # Prevent negative wounds
	print(character.name, " has been healed. Remaining wounds: ", character.wounds)

var wounds: int = 0  # Current wounds
var max_wounds: int = 3  # Example maximum wounds
var is_stunned: bool = false  # Track if the Teacher is stunned

func activate_special_ability() -> void:
	print(self.name, " activates Derringer Special!")
	lose_brawl()

func lose_brawl() -> void:
	wounds += 1  # Increment the wounds
	if wounds > max_wounds:  # Prevent exceeding max wounds
		wounds = max_wounds
	set_stunned(true)  # Mark the Teacher as stunned
	print(self.name, " has been wounded and is now stunned.")

func set_stunned(value: bool) -> void:
	is_stunned = value
	if value:
		print(self.name, " is now stunned.")
	else:
		print(self.name, " is not stunned.")

# Connect button action
func _ready() -> void:
	...
	special_abilities_button.connect("pressed", self, "_on_special_abilities_button_pressed")

func _on_special_abilities_button_pressed() -> void:
	print("Special abilities activated!")  # Replace with your logic

func pacify(character: Townsfolk) --> void:
	if me.pos == target.pos:
		 TileMapScene.church()
		print(self.name, " is now pacified ")

func puppy_love() -> void:

func cause_ruckus() -> void:

func enforce_law() -> void:

func manage_funds() -> void:
