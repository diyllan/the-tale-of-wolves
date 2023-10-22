extends Node3D

var cameraMovement1Started = false
var firstDialogue = false
var counter = 1
var prologueStarted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.connect("dialogue_ended", next_prologue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if cameraMovement1Started and !firstDialogue:
		firstDialogue = true
		$Camera3D/Timer.start()
		await $Camera3D/Timer.timeout
		DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")
		
func next_prologue():
	counter += 1
	if counter == 6:
		DialogueManager.disconnect("dialogue_ended", next_prologue)
		return
	DialogueManager.showDialogue("res://Assets/Dialogues/Prologue" + str(counter) + ".json")

func _on_animation_player_animation_started(anim_name):
	if anim_name == "CameraMovement1":
		cameraMovement1Started = true
