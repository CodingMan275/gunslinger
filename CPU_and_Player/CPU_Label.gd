extends Label


var OverAllHealth
var hasName = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(.2).timeout
	#Gets the parent node of its parent node
	var Order = get_parent().get_parent().Player_ID
	OverAllHealth = GlobalScript.PlayerNode[Order -1].Health

	text = str("CPU ", Order , "  " , OverAllHealth,"/",OverAllHealth)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var Order = get_parent().get_parent().Player_ID
	var  health = GlobalScript.PlayerNode[Order -1].Health
	
	text = str("CPU ", Order , "  " , health,"/",OverAllHealth)
	pass
