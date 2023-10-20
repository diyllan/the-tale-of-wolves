extends RayCast3D
#@onready var player = $"../../.."
func _physics_process(_delta):
	Ui.get_node("CanvasLayer/Prompt").text = ""
	Ui.get_node("CanvasLayer/Crosshair").self_modulate = Color("#ffffff")
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			Ui.get_node("CanvasLayer/Prompt").text = detected.get_prompt()
			Ui.get_node("CanvasLayer/Crosshair").self_modulate = Color("#770000")
			if Input.is_action_just_pressed(detected.prompt_action) and !get_parent().get_parent().get_parent().dialogueActive:
				detected.player = get_parent().get_parent().get_parent()
				detected.interact(owner)
				print_debug(detected.player)
