extends RayCast3D

func _physics_process(_delta):
	Ui.get_node("CanvasLayer/Prompt").text = ""
	Ui.get_node("CanvasLayer/Crosshair").self_modulate = Color("#ffffff")
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable: 
			Ui.get_node("CanvasLayer/Prompt").text = detected.get_prompt()
			Ui.get_node("CanvasLayer/Crosshair").self_modulate = Color("#770000")
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
