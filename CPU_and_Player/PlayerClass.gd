class Player:
	var ID: int
	var Cards: Array
	var ActionPoint: int = 2
	var Health : int = 20
	var location : Vector2

	func _init(id: int):
		ID = id
		Cards = []

	func add_card(card: Variant) -> void:
		Cards.append(card)

	func remove_card(card: Variant) -> void:
		Cards.erase(card)

	func get_card_count() -> int:
		return Cards.size()

	func GetLocation() -> Vector2:
		return location
