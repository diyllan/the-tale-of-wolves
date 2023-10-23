extends Node

var currentScene = null
var sceneChange = false
var nextScene

var world = preload("res://Scenes/world.tscn")

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
	animPlayer.play("TransOut")
	await animPlayer.animation_finished
	fadeoutRect.hide()

func changeScene(scenePath):
	var child = viewport.get_child(1)
	child.queue_free()
	var scene = world.instantiate()
	viewport.add_child(scene)
	SoundManager.stopAllSounds()
