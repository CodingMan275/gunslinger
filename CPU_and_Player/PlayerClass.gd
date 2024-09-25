class Player:
	var ID: int
	var Cards: Array

	func _init(id: int):
		ID = id
		Cards = []

	func add_card(card: Variant) -> void:
		Cards.append(card)

	func remove_card(card: Variant) -> void:
		Cards.erase(card)

	func get_card_count() -> int:
		return Cards.size()
