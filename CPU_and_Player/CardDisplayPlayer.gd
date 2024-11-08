extends CanvasLayer

var MinBound = 1
var Middle = 2
var MaxBound = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_parent().MidCard = get_parent().PlayerHand[Middle]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_left_pressed() -> void:

	MaxBound += 1
	Middle += 1
	MinBound += 1
	if MaxBound >= get_parent().PlayerHand.size():
		MaxBound = 1
	elif Middle >= get_parent().PlayerHand.size():
		Middle = 1
	elif MinBound >= get_parent().PlayerHand.size():
		MinBound = 1
	$Card3.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MaxBound]))
	$Card2.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[Middle]))
	get_parent().MidCard = get_parent().PlayerHand[Middle]
	$Card1.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MinBound]))

	pass # Replace with function body.
	
	

func _on_right_pressed() -> void:
	MaxBound -= 1
	Middle -= 1
	MinBound -= 1
	if MaxBound == 0:
		MaxBound = get_parent().PlayerHand.size() - 1
	elif Middle == 0:
		Middle = get_parent().PlayerHand.size() - 1
	elif MinBound == 0:
		MinBound = get_parent().PlayerHand.size() - 1
	$Card3.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MaxBound]))
	$Card2.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[Middle]))
	get_parent().MidCard = get_parent().PlayerHand[Middle]
	$Card1.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MinBound]))

	pass # Replace with function body.
	
	#I hopet his wroks forever becuase im fried
func refresh():
	$Card3.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MaxBound]))
	$Card2.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[Middle]))
	get_parent().MidCard = get_parent().PlayerHand[Middle]
	$Card1.texture = ResourceLoader.load(get_parent().CardNodeDeck.CardArt(get_parent().PlayerHand[MinBound]))
	pass
