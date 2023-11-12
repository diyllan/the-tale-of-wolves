class_name Interactable
extends Area3D

@export var Dialogue_Path = PackedStringArray([])
@export var prompt_message = ""
@export var prompt_action = "interact"
var world_path : String = "/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/"
#Door
var DoorisOpen = false

signal Interacted
var firstInteractionDay1 = false
var firstInteractionDay2 = false
var firstInteractionDay3 = false


var player

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return prompt_message + "\n[" + key_name + "]"
	
func interact(body):
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
		self.queue_free()
	
	if prompt_message == "Hole" and !body.hasPlanks:
		Interacted.emit()
		DialogueManager.showDialogue(Dialogue_Path[0])
		
	if prompt_message == "Pick up Planks":
		body.hasPlanks = true
		get_parent().hide()
		self.queue_free()
	
	if prompt_message == "Pick up Basket":
		body.enableLight = true
	
	if prompt_message == "Sleep":
		if ObjectiveManager.day_part_count == 3:
			SceneManager.wakeUpDay2()
		
		if ObjectiveManager.day_part_count == 7:
			SceneManager.wakeUpDay3()
#NPC DIALOGUE STUFF
	if prompt_message == "Mother":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 and !firstInteractionDay1:
			firstInteractionDay1 = true
			DialogueManager.showDialogue(Dialogue_Path[0])
		elif ObjectiveManager.day_part_count == 0 and firstInteractionDay1:
			DialogueManager.showDialogue(Dialogue_Path[1])
			
		if ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
		if ObjectiveManager.day_part_count == 4 and !firstInteractionDay2:
			firstInteractionDay2 = true
			DialogueManager.showDialogue(Dialogue_Path[3])
		elif ObjectiveManager.day_part_count == 4 and firstInteractionDay2:
			DialogueManager.showDialogue(Dialogue_Path[4])
			
		if ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[5])
			
		if ObjectiveManager.day_part_count == 8 and !firstInteractionDay3:
			firstInteractionDay3 = true
			DialogueManager.showDialogue(Dialogue_Path[6])
		elif ObjectiveManager.day_part_count == 8 and firstInteractionDay3:
			DialogueManager.showDialogue(Dialogue_Path[7])

	if prompt_message == "Talk to Baker":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 and !firstInteractionDay1:
			firstInteractionDay1 = true
			DialogueManager.showDialogue(Dialogue_Path[0])
		elif ObjectiveManager.day_part_count == 1 and firstInteractionDay1:
			DialogueManager.showDialogue(Dialogue_Path[1])
			
		if ObjectiveManager.day_part_count == 2:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[3])

		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[4])
			
	if prompt_message == "Talk to Blonde Boy":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])

	if prompt_message == "Talk to Brunhilde":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
		
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
	if prompt_message == "Talk to Erwin":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
		
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Ulf":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1:
			if !firstInteractionDay1:
				firstInteractionDay1 = true
				DialogueManager.showDialogue(Dialogue_Path[0])
			elif firstInteractionDay1:
				DialogueManager.showDialogue(Dialogue_Path[4])
				
		elif ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3 and firstInteractionDay1:
			DialogueManager.showDialogue(Dialogue_Path[1])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5:
			if !firstInteractionDay2:
				firstInteractionDay2 = true
				DialogueManager.showDialogue(Dialogue_Path[2])
			elif firstInteractionDay1:
				DialogueManager.showDialogue(Dialogue_Path[4])
			
		elif ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[3])
			
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[5])
			
	if prompt_message == "Talk to Siegfried":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Sarolf":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
	if prompt_message == "Talk to Arnulf":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Falko":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[1])
		
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[2])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[3])
			
	if prompt_message == "Talk to Wolf":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Adalbert":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			if !firstInteractionDay1:
				firstInteractionDay1 = true
				DialogueManager.showDialogue(Dialogue_Path[0])
			elif firstInteractionDay1:
				DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5:
			DialogueManager.showDialogue(Dialogue_Path[2])
				
		if ObjectiveManager.day_part_count == 6:
			DialogueManager.showDialogue(Dialogue_Path[3])
			
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[4])
	
	if prompt_message == "Talk to Alwina":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
	if prompt_message == "Talk to Rosaline":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Gwendolin":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
	
	if prompt_message == "Talk to Elfriede":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			if !firstInteractionDay1:
				firstInteractionDay1 = true
				DialogueManager.showDialogue(Dialogue_Path[0])
			elif firstInteractionDay1:
				DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[2])
			
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[3])
	
	if prompt_message == "Talk to Gertrud":
		Interacted.emit()
		if ObjectiveManager.day_part_count == 0 or ObjectiveManager.day_part_count == 1 or ObjectiveManager.day_part_count == 2 or ObjectiveManager.day_part_count == 3:
			DialogueManager.showDialogue(Dialogue_Path[0])
			
		if ObjectiveManager.day_part_count == 4 or ObjectiveManager.day_part_count == 5 or ObjectiveManager.day_part_count == 6 or ObjectiveManager.day_part_count == 7:
			DialogueManager.showDialogue(Dialogue_Path[1])
				
		if ObjectiveManager.day_part_count == 8 or ObjectiveManager.day_part_count == 9 or ObjectiveManager.day_part_count == 10 or ObjectiveManager.day_part_count == 11:
			DialogueManager.showDialogue(Dialogue_Path[2])
