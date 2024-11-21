extends Control

@onready var VictoryMusic = $"../Player1VictoryScreen/VictoryMusic"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	
	playVictory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playVictory():
	VictoryMusic.play()
