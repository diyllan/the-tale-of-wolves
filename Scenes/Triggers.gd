extends Node3D

@onready var cutscene = $"../CutscenePlayer"
@onready var BoyAnimations = $"../NPC/Villagers/Boy/BoyAnim/AnimationPlayer"
var BoyWhoCriesWolf1 = false
var BoyWhoCriesWolf1Ended = false
@export var BoyWhoCriesWolfDialogueDay1: String
var BoyWhoCriesWolf2 = false
@export var BoyWhoCriesWolfDialogueDay2: String
var BoyWhoCriesWolf3 = false
@export var BoyWhoCriesWolfDialogueDay3: String

var FirstForestScarePlayed = false
var FirstForestScareEnded = false
@export var FirstForestScare: String

var weirdGuyScare1 = false
var weirdGuyScare1Ended = false
var weirdGuyScare1Reset = false
@export var WirdGuyDialogue1: String
var TensionSoundPlayed = false

signal cutsceneStart
signal cutsceneEnd
signal WeirdGuySceneStart
signal WeirdGuySceneEnd
signal BoyCutSceneStart
signal BoyCutSceneEnd

func _ready():
	DialogueManager.connect("dialogue_ended", DialogueEnded)
	
func _on_boy_who_cries_wolf_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 0 and !BoyWhoCriesWolf1:
			BoyCutSceneStart.emit()
			BoyWhoCriesWolf1 = true
			cutscene.play("BoyWhoCriesWolf1")
			await cutscene.animation_finished
			DialogueManager.showDialogue(BoyWhoCriesWolfDialogueDay1)
			BoyAnimations.play("Yelling")
#		if ObjectiveManager.day_part_count == 4 and !BoyWhoCriesWolf2:
#			BoyCutSceneStart.emit()
#			BoyWhoCriesWolf2 = true
#			cutscene.play("BoyWhoCriesWolf2")
#		if ObjectiveManager.day_part_count == 8 and !BoyWhoCriesWolf3:
#			BoyCutSceneStart.emit()
#			BoyWhoCriesWolf3 = true
#			cutscene.play("BoyWhoCriesWolf3")

func DialogueEnded():
	if BoyWhoCriesWolf1 and !BoyWhoCriesWolf1Ended:
			BoyWhoCriesWolf1Ended = true
			cutscene.play("Return")
			BoyCutSceneEnd.emit()

	if weirdGuyScare1 and !weirdGuyScare1Ended:
			weirdGuyScare1Ended = true
			cutscene.play("Reset")
			WeirdGuySceneEnd.emit()
			cutsceneEnd.emit()
			
	if FirstForestScarePlayed and !FirstForestScareEnded:
		FirstForestScareEnded = true
		cutsceneEnd.emit()


func _on_silo_hole_body_entered(body):
	if body.is_in_group("Player"):
		SceneManager.playFadeIn()
		cutscene.play("Hole")
		await cutscene.animation_finished
		SceneManager.playFadeOut()
		# Load Checkpoint here
		print_debug("You died / Checkpoint")


func _on_first_forest_scare_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 0 and !FirstForestScarePlayed:
			cutsceneStart.emit()
			FirstForestScarePlayed = true
			body.get_node("TreeBranch").play()
			DialogueManager.showDialogue(FirstForestScare)

func _on_weird_guy_1_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 3 and !weirdGuyScare1:
			weirdGuyScare1 = true
			WeirdGuySceneStart.emit()
			cutsceneStart.emit()
			cutscene.play("WeirdGuyScare1")
			SoundManager.stopLastSound("TensionSound")
			SoundManager.playSound("SimpleJumpscare")
			DialogueManager.showDialogue(FirstForestScare)

func _on_tension_sound_trigger_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 3 and !weirdGuyScare1 and !TensionSoundPlayed:
			TensionSoundPlayed = true
			SoundManager.playSound("TensionSound")

func _on_weird_return_pos_1_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 3 and weirdGuyScare1Ended and !weirdGuyScare1Reset:
			weirdGuyScare1Reset = true
			cutscene.play("WeirdGuyReturnPos")
