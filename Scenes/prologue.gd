extends Node3D

var cameraMovement1Started = false
var firstDialogue = false
var counter = 1
var animCounter = 1
var prologueStarted = false
var DARK_RED = Color(0.545098, 0, 0, 1)
var biteReady = false
var finalDialogue = false

@onready var animPlayer = $Camera3D/AnimationPlayer
@onready var bite_prompt = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/PrologueBitePrompt")
func _ready():
	DialogueManager.connect("dialogue_ended", next_prologue)
	
func _process(_delta):
	if biteReady:
		bite_prompt.show()
		var tween = create_tween()
		tween.tween_property(bite_prompt, "modulate:a", 255, 0.5)
		await tween.finished
		if Input.is_action_just_pressed("interact"):
			biteReady = false
			var Colortween = create_tween()
			Colortween.tween_property(bite_prompt, "modulate", DARK_RED, 1)
			Colortween.tween_property(bite_prompt, "modulate:a", 0, 1)
			SoundManager.playSound("Bite")
			SoundManager.playSound("Shotgun")
			SoundManager.playNextSound("Whimper")
			SoundManager.playSound("LeavesRushling")
			animPlayer.play("CameraMovement7")
			await animPlayer.animation_finished
			bite_prompt.hide()
			SceneManager.changeSceneWithTransition(SceneManager.world)
			
	if cameraMovement1Started and !firstDialogue:
		firstDialogue = true
		$Camera3D/Timer.start()
		await $Camera3D/Timer.timeout
		DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")
		
func next_prologue():
	animCounter += 1
	if animCounter != 7:
		animPlayer.play("CameraMovement" + str(animCounter))
		if animCounter == 6:
			DialogueManager.disconnect("dialogue_ended", next_prologue)
			await animPlayer.animation_finished
			biteReady = true
			
	if counter != 6 and !finalDialogue:
		counter += 1
		DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")
		if counter == 5:
			finalDialogue = true

func _on_animation_player_animation_started(anim_name):
	if anim_name == "CameraMovement1":
		cameraMovement1Started = true
