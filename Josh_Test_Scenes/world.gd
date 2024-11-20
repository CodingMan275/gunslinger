extends Node2D
#LAN Multiplayer tutorial https://www.youtube.com/watch?v=M0LJ9EsS_Ak

#Peer can be both a client or host, its just who you are
var peer

@onready var property_container = $CanvasLayer/Container/VBoxContainer


#This is what the player will be, whatever the player controller is plug in here
@export var player_scene : PackedScene

@onready var line_edit = get_node("CanvasLayer/LineEdit")

func _ready():
	line_edit.grab_focus()
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(ServerConnected)
	multiplayer.connection_failed.connect(ServerFailed)
	
	
	#Server and clients called
func PlayerConnected(ID):
	print("Player Connected " + str(ID))
	if(multiplayer.is_server()):
		$CanvasLayer/Start.show()
	#Serber and slients called
func PlayerDisconnected(ID):
	print("Player Disconnected " + str(ID))
	#if multiplayer.is_server():
	peer.close()
	#var GameScene = load("res://main_menu/main_menu.tscn").instantiate()
	get_tree().root.get_node("Node2D").queue_free()
#	get_tree().root.add_child(GameScene)
	GlobalScript.clear()
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	
	#Called only from clients
func ServerConnected():
	print("Connected to server")
	#Calling the host to take this peer's infor and then disperse it
	#Format for rpc (Host ID, Peer Name, Peer Unique ID)
	SendPlayerInfo.rpc_id(1, $CanvasLayer/LineEdit2.text, multiplayer.get_unique_id())
	# Need to get the host's title but idk how
	'''
	add($CanvasLayer/LineEdit2.text)
	'''
	add.rpc($CanvasLayer/LineEdit2.text)
	#Ony called from clients
func ServerFailed():
	print("Failed to connect")

#Creating a server on someones machine
func _on_host_pressed() -> void:
	
	#Peer can be both a client or host, its just who you are
	peer = ENetMultiplayerPeer.new()
	
	#Will get a window user's LAN IP address, each device has its own unique
	#LAN IP which needs to be shared somehow
	#https://forum.godotengine.org/t/how-to-get-local-ip-address/10399/2
	var LAN_IP = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	print(LAN_IP)
	
	#Error message
	var error = peer.create_server(1027)
	if error != OK:
		print("Error: ", error)
		#_close_server()
		#_on_host_pressed()
		return
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)

	#Makes the host now also a peer so it can actually play the game
	multiplayer.set_multiplayer_peer(peer)	
	SendPlayerInfo($CanvasLayer/LineEdit2.text, multiplayer.get_unique_id())
	add.rpc($CanvasLayer/LineEdit2.text)
	#$CanvasLayer/Start.show()
	$CanvasLayer/Host.hide()
	$CanvasLayer/Join.hide()
	$CanvasLayer/LineEdit.hide()
	$CanvasLayer/Container.show()

#Joining someone who is hosting the game
#Joining someone who is hosting the game
func _on_join_pressed() -> void:
	
	peer = ENetMultiplayerPeer.new()
	
	#IP of SUNY Poly, can be changed later
	peer.create_client(line_edit.text, 1027)
	#peer.create_client("192.168.201.81", 1027)
	
	#Same compress of CPU and bandwidth resources
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	#Create client peer
	multiplayer.set_multiplayer_peer(peer)
	
	$CanvasLayer/Host.hide()
	$CanvasLayer/Join.hide()
	$CanvasLayer/LineEdit.hide()
	$CanvasLayer/Container.show()
	
	for i in GlobalScript.PlayerInfo:
		print(GlobalScript.PlayerInfo[i])
	#Canvas no longer needed
#	$CanvasLayer.hide()


func _close_server():
	print("no")
	# Help





func _on_start_pressed() -> void:
	GameSceneStart.rpc()
	pass # Replace with function body.
	


@rpc("any_peer","call_local")
func add(title : String):
	if title.length() < 1:
		title = str("Player")
	var property
	property = property_container.find_child(title,true)
	property = Label.new()
	property_container.add_child(property)
	property.theme = Theme.new()
	property.add_theme_font_size_override(" ", 60)
	property.text = title
	



#Creating the game scene on start
#This rpc will send out to all peers and the local machine, everyone will do this function
@rpc("any_peer","call_local")
func GameSceneStart():
	var GameScene = load("res://Main_Scene_Board/node_2d.tscn").instantiate()
	get_tree().root.add_child(GameScene)
	$CanvasLayer.hide()
	
@rpc("any_peer")
#This first sends the info to the MultiplayerManager on the hosts end
func SendPlayerInfo(name, ID):
	if !GlobalScript.PlayerInfo.has(ID):
		GlobalScript.PlayerInfo[ID]= {
			"name": name,
			"ID": ID,			
		}
		#Then it is RPC'd to dispress the information to everyone
	if multiplayer.is_server():
		for i in GlobalScript.PlayerInfo:
			SendPlayerInfo.rpc(GlobalScript.PlayerInfo[i].name, i)
