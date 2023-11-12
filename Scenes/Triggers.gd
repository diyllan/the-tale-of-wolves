extends Node3D

@onready var cutscene = $"../CutscenePlayer"
@onready var BoyAnimations = $"../NPC/Villagers/Boy/BoyAnim/AnimationPlayer"
var BoyWhoCriesWolf1 = false
var BoyWhoCriesWolf1Ended = false
@export var BoyWhoCriesWolfDialogueDay1: String
var BoyWhoCriesWolf2 = false
var BoyWhoCriesWolf2Ended = false
@export var BoyWhoCriesWolfDialogueDay2: String
var BoyWhoCriesWolf3 = false
var BoyWhoCriesWolf3Ended = false
@export var BoyWhoCriesWolfDialogueDay3: String

var FirstForestScarePlayed = false
var FirstForestScareEnded = false
@export var FirstForestScare: String

var weirdGuyScare1 = false
var weirdGuyScare1Ended = false
var weirdGuyScare1Reset = false
@export var WeirdGuyDialogue1: String
var TensionSoundPlayed = false

var weirdGuyScare2 = false
var weirdGuyScare3 = false
var weirdGuyScare2Ended = false
var weirdGuyScare2Reset = false
@export var WeirdGuyDialogue2: String

signal cutsceneStart
signal cutsceneEnd
signal WeirdGuySceneStart
signal WeirdGuySceneEnd
signal WeirdGuyScene2Start
signal WeirdGuyScene2End
signal BoyCutSceneStart
signal BoyCutSceneEnd

func _ready():
	DialogueManager.connect("dialogue_ended", DialogueEnded)

func DialogueEnded():
	if BoyWhoCriesWolf1 and !BoyWhoCriesWolf1Ended:
			BoyWhoCriesWolf1Ended = true
			cutscene.play("Return")
			BoyCutSceneEnd.emit()
			cutsceneEnd.emit()
	if BoyWhoCriesWolf2 and !BoyWhoCriesWolf2Ended:
			BoyWhoCriesWolf2Ended = true
			cutscene.play("Return")
			BoyCutSceneEnd.emit()
			cutsceneEnd.emit()
	if BoyWhoCriesWolf3 and !BoyWhoCriesWolf3Ended:
			BoyWhoCriesWolf3Ended = true
			cutscene.play("BoyWhoCriesWolfRunninginWoods")
			await cutscene.animation_finished
			cutscene.play("Return")
			cutsceneEnd.emit()

	if weirdGuyScare1 and !weirdGuyScare1Ended:
			weirdGuyScare1Ended = true
			cutscene.play("RESET")
			WeirdGuySceneEnd.emit()
			cutsceneEnd.emit()
			
	if FirstForestScarePlayed and !FirstForestScareEnded:
		FirstForestScareEnded = true
		cutsceneEnd.emit()
	
	if weirdGuyScare2 and !weirdGuyScare2Ended:
			weirdGuyScare2Ended = true
			cutscene.play("RESET")
			WeirdGuyScene2End.emit()
			cutsceneEnd.emit()

func _on_boy_who_cries_wolf_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 0 and !BoyWhoCriesWolf1:
			cutsceneStart.emit()
			cutscene.play("BoyWhoCriesWolfRepos")
			BoyCutSceneStart.emit()
			BoyWhoCriesWolf1 = true
			cutscene.play("BoyWhoCriesWolf1")
			await cutscene.animation_finished
			DialogueManager.showDialogue(BoyWhoCriesWolfDialogueDay1)
			BoyAnimations.play("Yelling")
		if ObjectiveManager.day_part_count == 4 and !BoyWhoCriesWolf2:
			cutsceneStart.emit()
			cutscene.play("BoyWhoCriesWolfRepos")
			BoyCutSceneStart.emit()
			BoyWhoCriesWolf2 = true
			cutscene.play("BoyWhoCriesWolf1")
			await cutscene.animation_finished
			DialogueManager.showDialogue(BoyWhoCriesWolfDialogueDay2)
			BoyAnimations.play("Yelling")
		if ObjectiveManager.day_part_count == 9 and !BoyWhoCriesWolf3:
			cutsceneStart.emit()
			cutscene.play("BoyWhoCriesWolfRepos")
			BoyCutSceneStart.emit()
			BoyWhoCriesWolf3 = true
			cutscene.play("BoyWhoCriesWolf1")
			await cutscene.animation_finished
			DialogueManager.showDialogue(BoyWhoCriesWolfDialogueDay3)
			BoyAnimations.play("Yelling")


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
			DialogueManager.showDialogue(WeirdGuyDialogue1)
		
		


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


func _on_weird_guy_2_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 7 and !weirdGuyScare2:
			cutscene.play("WeirdGuyRepos1")
			weirdGuyScare2 = true
			WeirdGuySceneStart.emit()
			SoundManager.playSound("TensionSound")


func _on_weird_guy_chase_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 7 and !weirdGuyScare3 and weirdGuyScare2:
			weirdGuyScare3 = true
			WeirdGuySceneEnd.emit()
			WeirdGuyScene2Start.emit()
			cutsceneStart.emit()
			cutscene.play("WeirdGuyScare2")
			SoundManager.stopLastSound("TensionSound")
			SoundManager.playSound("SimpleJumpscare")
			DialogueManager.showDialogue(WeirdGuyDialogue2)


func _on_weird_return_pos_2_body_entered(body):
	if body.is_in_group("Player"):
			cutscene.play("WeirdGuyReturnPos")
