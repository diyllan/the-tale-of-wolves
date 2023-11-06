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

signal cutsceneStart
signal cutsceneEnd

func _ready():
	DialogueManager.connect("dialogue_ended", DialogueEnded)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		if ObjectiveManager.day_part_count == 0 and !BoyWhoCriesWolf1:
			cutsceneStart.emit()
			BoyWhoCriesWolf1 = true
			cutscene.play("BoyWhoCriesWolf1")
			await cutscene.animation_finished
			DialogueManager.showDialogue(BoyWhoCriesWolfDialogueDay1)
			BoyAnimations.play("Yelling")
		if ObjectiveManager.day_part_count == 4 and !BoyWhoCriesWolf2:
			cutsceneStart.emit()
			BoyWhoCriesWolf2 = true
			cutscene.play("BoyWhoCriesWolf2")
		if ObjectiveManager.day_part_count == 8 and !BoyWhoCriesWolf3:
			cutsceneStart.emit()
			BoyWhoCriesWolf3 = true
			cutscene.play("BoyWhoCriesWolf3")

func DialogueEnded():
	if BoyWhoCriesWolf1 and !BoyWhoCriesWolf1Ended:
			BoyWhoCriesWolf1Ended = true
			cutscene.play("Return")
			cutsceneEnd.emit()
