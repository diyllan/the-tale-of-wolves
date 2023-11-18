extends CharacterBody3D

enum {
	IDLE,
	WALKING,
	TALKING,
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var state = IDLE

var interacted = false
var dialogue_ended = false


@onready var animPlayer = get_child(0).get_node("AnimationPlayer")

var cutscene = false

func _ready():
	$StaticBodyInteraction.connect("Interacted", interaction)
#	DialogueManager.connect("dialogue_started", interaction)
	DialogueManager.connect("dialogue_ended", interaction_ended)
	
	
func _process(delta):
	var player = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player")
	velocity = Vector3.ZERO
	setGravity(delta)
	
	match state:
		IDLE:
			animPlayer.play("Idle")

		TALKING:
			look_at(player.global_transform.origin, Vector3.UP)
			animPlayer.play("Talking")
			if !interacted:
				state = IDLE
				
	move_and_slide()
	
func setGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func interaction():
	interacted = true
	state = TALKING

func interaction_ended():
	interacted = false
