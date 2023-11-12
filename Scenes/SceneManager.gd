extends Node

var currentScene = null
var sceneChange = false
var nextScene

var world = preload("res://Scenes/world.tscn")
var test = preload("res://Scenes/Testing/npc_testing.tscn")

@onready var fadeoutRect = $CanvasLayer/ColorRect
@onready var animPlayer = $AnimationPlayer
@onready var viewport = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport")
# Called when the node enters the scene tree for the first time.
func _ready():
	fadeoutRect.hide()
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

func changeSceneWithTransition(scenePath):
	fadeoutRect.show()
	animPlayer.play("TransIn")
	await animPlayer.animation_finished
	var child = viewport.get_child(1)
	child.queue_free()
	var scene = scenePath.instantiate()
	viewport.add_child(scene)
	SoundManager.stopAllSounds()
	SoundManager.playAmbience("NatureAmbience")
	animPlayer.play("TransOut")
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI").titleScreen = false
	wakeUpDay1()
	await animPlayer.animation_finished
	fadeoutRect.hide()
	
func reloadSceneWithTransition(scenePath):
	fadeoutRect.show()
	animPlayer.play("TransIn")
	await animPlayer.animation_finished
	var child = viewport.get_child(1)
	child.queue_free()
	var scene = scenePath.instantiate()
	viewport.add_child(scene)
	SoundManager.stopAllSounds()
	SoundManager.playAmbience("NatureAmbience")
	animPlayer.play("TransOut")
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI").titleScreen = false
	await animPlayer.animation_finished
	fadeoutRect.hide()
	SaveLoad.load_game()

func changeScene(scenePath):
	var child = viewport.get_child(1)
	child.queue_free()
	var scene = scenePath.instantiate()
	viewport.add_child(scene)
	SoundManager.stopAllSounds()
	SoundManager.playAmbience("NatureAmbience")
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI").titleScreen = false

func playTransition(sound = ""):
	fadeoutRect.show()
	animPlayer.play("TransIn")
	await animPlayer.animation_finished
	if sound != "":
		SoundManager.playSound("")
	animPlayer.play("TransOut")
	await animPlayer.animation_finished
	fadeoutRect.hide()

func playFadeIn():
	fadeoutRect.show()
	animPlayer.play("TransIn")


func playFadeOut():
	animPlayer.play("TransOut")
	await animPlayer.animation_finished
	fadeoutRect.hide()

func wakeUpDay1():
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = true
	animPlayer.play("WakeUpDay1")
	await animPlayer.animation_finished
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = false

func wakeUpDay2():
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = true
	animPlayer.play("WakeUpDay2")
	await animPlayer.animation_finished
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = false

func wakeUpDay3():
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = true
	animPlayer.play("WakeUpDay3")
	await animPlayer.animation_finished
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player").cutscene = false
