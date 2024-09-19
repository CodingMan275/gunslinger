class_name Card extends Node2D


@export var Card_name: String = " Card Name "
@export var Card_description : String = " Card Description"
@export var card_cost : int = 1
@export var Card_image: Node2D 



@onready var cost_lbl: Label = $CostDisplay/Costlbl
@onready var name_lbl: Label = $CardName/Namelbl
@onready var description_lbl: Label = $CardDescription


func _ready():
	set_card_values(card_cost, card_name< card description)
	visible = false 
	
	func set_values(_cost: int , _name: String, _description : String):
		
		card_name = _name 
		card_description = _description 
		card_cost = _cost
		
		
		
	cost_lbl.set_text(str(card_cost))
	name_lbl.set_text(card_name)
	description_lbl.set_text(card_description)
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
