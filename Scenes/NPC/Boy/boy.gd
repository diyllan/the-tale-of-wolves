extends CharacterBody3D

enum {
	IDLE,
	WALKING,
	TALKING,
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var state

var target_vector: Vector3
var last_target_vector: Vector3 
var radiusx1 = -360
var radiusx2 = -280
var radiusz1 = -570
var radiusz2 = -415
var TOLERANCE = 4.0

var interacted = false
var dialogue_ended = false

@export var SPEED = 5

@onready var animPlayer = get_child(0).get_node("AnimationPlayer")
@onready var nav_agent = $NavigationAgent3D
@onready var idle_Walking_timer = $Idle_Walking
@onready var player = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/Player")

var cutscene = false

func _ready():
	nav_agent.velocity_computed.connect(_on_nav_velocity_computed)
	$StaticBodyInteraction.connect("Interacted", interaction)
#	DialogueManager.connect("dialogue_started", interaction)
	DialogueManager.connect("dialogue_ended", interaction_ended)
	update_target_position()
	
	$"../../../Triggers".connect("cutsceneStart", CutsceneStart)
	$"../../../Triggers".connect("cutsceneEnd", CutsceneEnd)
	
func CutsceneStart():
	cutscene = true
func CutsceneEnd():
	cutscene = false
	state = WALKING

func _process(delta):
	if cutscene:
		return
	
	velocity = Vector3.ZERO
	setGravity(delta)
	
	match state:
		WALKING:
			animPlayer.play("Running")
			random_roaming()
			if nav_agent.is_navigation_finished():
				update_target_position()

		TALKING:
			look_at(player.global_transform.origin)
			animPlayer.play("Idle")
			if !interacted:
				update_target_position()
				state = WALKING
			
func setGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func _on_nav_velocity_computed(safe_velocity: Vector3) -> void:
	if !interacted and state == WALKING:
		velocity = safe_velocity
		look_at(nav_agent.get_next_path_position())
		move_and_slide()
	
	
func update_target_position():
	if target_vector == last_target_vector:
		target_vector = Vector3(randi_range(radiusx1, radiusx2),  0, randi_range(radiusz1, radiusz2))

func random_roaming():
	last_target_vector = target_vector 
	nav_agent.set_target_position(target_vector)
	var direction = (nav_agent.get_next_path_position() - global_transform.origin).normalized()
	
	var intended_velocity = direction * SPEED
	nav_agent.set_velocity(intended_velocity)
	
	

func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return (target_vector - global_position).length() < TOLERANCE

func interaction():
	interacted = true
	state = TALKING

func interaction_ended():
	interacted = false
