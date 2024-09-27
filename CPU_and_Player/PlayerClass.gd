class Player:
	var ID: int
	var Cards: Array
	var health : int

	func _init(id: int):
		ID = id
		Cards = []

	func add_card(card: Variant) -> void:
		Cards.append(card)

	func remove_card(card: Variant) -> void:
		Cards.erase(card)

	func get_card_count() -> int:
		return Cards.size()
