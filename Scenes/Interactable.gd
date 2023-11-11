class_name Interactable
extends Area3D

@export var Dialogue_Path = ""
@export var prompt_message = ""
@export var prompt_action = "interact"
var world_path : String = "/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/"
#Door
var DoorisOpen = false

signal Interacted

var player

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return prompt_message + "\n[" + key_name + "]"
	
func interact(body):
	if Dialogue_Path != "" and !body.hasPlanks:
		Interacted.emit()
		DialogueManager.showDialogue(Dialogue_Path)
	
	if prompt_message == "hide":
		body.hiding = true
		body.hidingPos = get_parent().get_node("HidingPos")
		body.currentCamPosHiding = body.global_position
		body.yMaxRotation = 100
		body.yMinRotation = -10
#		if body.hiding:
#			prompt_message = "leave"
	if (prompt_message == "Open Door" or prompt_message == "To Grandma") and !DoorisOpen:
		DoorisOpen = true
		$"../AnimationPlayer".play("Open")
		await $"../AnimationPlayer".animation_finished
		prompt_message = "Close Door"
	elif prompt_message == "Close Door" and DoorisOpen:
		DoorisOpen = false
		$"../AnimationPlayer".play("Close")
		await $"../AnimationPlayer".animation_finished
		prompt_message = "Open Door"
		
	if prompt_message == "Hole" and body.hasPlanks:
		var plank = get_parent().get_node("planks")
		plank.show()
		plank.get_node("StaticBody3D").set_collision_layer_value(1, true)
		body.hasPlanks = false
		self.queue_free()
		
	if prompt_message == "Pick up Planks":
		body.hasPlanks = true
		get_parent().hide()
		self.queue_free()
