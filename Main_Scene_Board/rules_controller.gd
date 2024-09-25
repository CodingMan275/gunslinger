extends Node

@export var Turn_Order = 1

signal order

#This could be used for signals and such for spawning players
@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Turn_Order = 1
	
	#Spawn player 1
	var scene1 = preload("res://Josh_Test_Scenes/Player.tscn").instantiate()
# Add the node as a child of the node the script is attached to.
	add_child(scene1)
	
	#Spawn player 2
	var scene2 = preload("res://Josh_Test_Scenes/Player.tscn").instantiate()
# Add the node as a child of the node the script is attached to.
	add_child(scene2)
	
	scene1.Player_ID = 1
	scene2.Player_ID = 2
	
	
	order.emit(Turn_Order)
	
	pass # Replace with function body.
	
func _on_button_pressed() -> void:
	#Incremements Turn Order
	Turn_Order = Turn_Order + 1
	if Turn_Order == 3:
		Turn_Order = 1
	order.emit(Turn_Order)
	pass # Replace with function bod
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_child_order_changed() -> void:
	pass # Replace with function body

	
	
	#LAN JOSH STUFF
#LAN Multiplayer tutorial https://www.youtube.com/watch?v=M0LJ9EsS_Ak
"""

All nonsense LAN ignore and focus on pass and play


#Turn order
@export var Turn_Order = 1
signal Send_Turn

#Player sends a signal asking for what turn order it is
#And then the world controller sends back a signal with what turn it is

#INcrement turn order
@rpc("any_peer")
func _on_button_pressed() -> void:
	#Turn order updated
	Turn_Order = Turn_Order + 1
	#Max two players for this test
	if Turn_Order == 3:
		Turn_Order = 1
	#Check
	print(Turn_Order)
	Send_Turn.emit(Turn_Order)

#Peer can be both a client or host, its just who you are
var peer = ENetMultiplayerPeer.new()

#This is what the player will be, whatever the player controller is plug in here
@export var player_scene : PackedScene

@onready var line_edit = get_node("CanvasLayer/LineEdit")

#Creating a server on someones machine
func _on_host_pressed() -> void:

	#Will get a window user's LAN IP address, each device has its own unique
	#LAN IP which needs to be shared somehow
	#https://forum.godotengine.org/t/how-to-get-local-ip-address/10399/2
	var LAN_IP = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	print(LAN_IP)

	#Arbitrary port, can be changed later or can be made inputable
	peer.create_server(1027)
	#creates the peer who is hosting
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	#Add the player to the scene / game
	add_player()
	#Canvas no longer needed
	$CanvasLayer/Join.hide()
	$CanvasLayer/Host.hide()
	$CanvasLayer/LineEdit.hide()
#Joining someone who is hosting the game
func _on_join_pressed() -> void:
	#IP of SUNY Poly, can be changed later
	peer.create_client(line_edit.text, 1027)
	#Create client peer
	multiplayer.multiplayer_peer = peer
	

	
	#Canvas no longer needed
	$CanvasLayer/Join.hide()
	$CanvasLayer/Host.hide()
	$CanvasLayer/LineEdit.hide()
	
	#Adding player number 1
func add_player(id = 1):
	#Create an instance of the player scene
	var player = player_scene.instantiate()
	#Makes the player name the ID
	player.name = str(id)
	#This should make the instance of the character a child of then scene
	call_deferred("add_child", player)
	
	
	#Exiting the game
	#This does not work as intended, client is not properly deleted
	#If host dissconects no one else is booted
	#Probably has soething to do with clients not having IDs yet
	#Unclear on how dissconnecting mid match and rejoing would work
	#I feel confident I could make it work.
	#Really unclear on how save states would work, not as confident in that
func exit_game(id):
	#Deletes host player when they dissconnect
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
#Calls rpc for deleting players when it dissconnected
#Not sure why we need two functions del_player and _del_player
#Just followed tutorial and it broke when I tried to make it more compact
#A non-issue
func del_player(id):
	rpc("_del_player", id)
	
#RPC is very important for multiplayer in godot, apparently
@rpc("any_peer","call_local")

#Finally deletes player with ID
func _del_player(id):
	#deletes node in the world scene
	get_node(str(id)).queue_free()
"""
