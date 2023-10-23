extends Node3D

var cameraMovement1Started = false
var firstDialogue = false
var counter = 1
var animCounter = 1
var prologueStarted = false
var DARK_RED = Color(0.545098, 0, 0, 1)
var biteReady = false
@onready var animPlayer = $Camera3D/AnimationPlayer
@onready var bite_prompt = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/PrologueBitePrompt")
func _ready():
	DialogueManager.connect("dialogue_ended", next_prologue)
	
func _process(delta):
	if Input.is_action_just_pressed("interact") and biteReady:
		var tween = create_tween()
		tween.tween_property(bite_prompt, "modulate", DARK_RED, 1)
		tween.tween_property(bite_prompt, "modulate:a", 0, 1)
		SoundManager.playSound("Bite")
		SoundManager.playSound("Shotgun")
		SoundManager.playNextSound("Whimper")
		SoundManager.playSound("LeavesRushling")
		animPlayer.play("CameraMovement7")
		await animPlayer.animation_finished
		SceneManager.changeSceneWithTransition(SceneManager.world)
		
	if cameraMovement1Started and !firstDialogue:
		firstDialogue = true
		$Camera3D/Timer.start()
		await $Camera3D/Timer.timeout
		DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")
		
func next_prologue():
	counter += 1
	animCounter += 1
	if animCounter != 7:
		animPlayer.play("CameraMovement" + str(animCounter))
		if animCounter == 6:
			await animPlayer.animation_finished
			biteReady = true
			bite_prompt.show()
			var tween = create_tween()
			tween.tween_property(bite_prompt, "modulate:a", 255, 1)
			
	if counter == 6:
		DialogueManager.disconnect("dialogue_ended", next_prologue)
		return
	DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")
	

func _on_animation_player_animation_started(anim_name):
	if anim_name == "CameraMovement1":
		cameraMovement1Started = true
