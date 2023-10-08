extends RayCast3D

@onready var prompt = $Prompt

func _physics_process(delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable: 
			prompt.text = detected.get_prompt()
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
