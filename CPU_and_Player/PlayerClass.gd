class Player:
	var ID: int
	var Cards: Array
	var Health : int = 7
	
	var SpawnLoc : Vector2
	var location : Vector2

	var ActionPoint: int = 2
	var AttackRange: int = 2
	
	
	
	func _init(id: int):
		ID = id
		Cards = []

	func add_card(card: Variant) -> void:
		Cards.append(card)

	func remove_card(card: Variant) -> void:
		Cards.erase(card)

	func GetLocation() -> Vector2:
		return location
