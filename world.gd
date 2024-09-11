extends Node2D

#LAN Multiplayer tutorial https://www.youtube.com/watch?v=M0LJ9EsS_Ak

#As of right now it is hard coded to only work When
#Josh hosts the game because of the LAN IP address
#Working on better solutions now

#Just something to prove LAN is possible with basic movements
#I feel confident that if we get a world controller / automatic rules controller
#it would be easy to properly sync and async what is needed per player

#Peer can be both a client or host, its just who you are
var peer = ENetMultiplayerPeer.new()

#This is what the player will be, whatever the player controller is plug in here
@export var player_scene : PackedScene

#Creating a server on someones machine
func _on_host_pressed() -> void:
	#Will get a window user's LAN IP address, each device has its own unique
	#LAN IP which needs to be shared somehow
	#https://forum.godotengine.org/t/how-to-get-local-ip-address/10399/2
	var LAN_IP = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	#Arbitrary port, can be changed later or can be made inputable
	peer.create_server(1027)
	#creates the peer who is hosting
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	#Add the player to the scene / game
	add_player()
	#Canvas no longer needed
	$CanvasLayer.hide()

#Joining someone who is hosting the game
func _on_join_pressed() -> void:
	#IP of SUNY Poly, can be changed later
	peer.create_client("192.168.192.103", 1027)
	#Create client peer
	multiplayer.multiplayer_peer = peer
	#Here would be code for assigning player ID's for turn order
	#Will be done later
	
	#Canvas no longer needed
	$CanvasLayer.hide()
	
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
	
