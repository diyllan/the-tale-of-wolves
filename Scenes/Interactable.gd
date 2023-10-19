class_name Interactable
extends StaticBody3D

@export var Dialogue_Path = ""
@export var prompt_message = ""
@export var prompt_action = "interact"

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return prompt_message + "\n[" + key_name + "]"
	
func interact(body):
	if Dialogue_Path != "":
		DialogueManager.showDialogue(Dialogue_Path)
	
	if prompt_message == "hide":
		body.hiding = true
		body.hidingPos = get_parent().get_node("HidingPos")
		body.currentCamPosHiding = body.global_position
		body.yMaxRotation = 100
		body.yMinRotation = -10
#		if body.hiding:
#			prompt_message = "leave"
	if prompt_message == "Open Door":
		var tween = create_tween()
		tween.tween_property(get_parent().get_parent().get_parent(), "rotation", Vector3(0,90,0), 0.5)
	
