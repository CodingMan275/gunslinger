extends Node

var DebugScript # refrence to DebugPanel Script
 
var PlayerInfo = {}

var CPUInfo = {}

var PlayerNode : Array

var SinglePlay : bool = false

func clear():
	PlayerInfo.clear()
	CPUInfo.clear()
	PlayerNode.clear()
	DebugScript.property_container.queue_free()
	SinglePlay = false
