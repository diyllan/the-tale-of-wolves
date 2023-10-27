extends CharacterBody3D

enum {
	IDLE,
	WALKING,
	TALKING,
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var state = IDLE

var target_vector: Vector3
var last_target_vector: Vector3 
var radius = 100
var TOLERANCE = 4.0

var interacted = false
var dialogue_ended = false

var randomTime

@export var SPEED = 3

@onready var animPlayer = $Man1Anim/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D
@onready var idle_Walking_timer = $Idle_Walking
@onready var player = get_node("../Player")

func _ready():
	$StaticBodyInteraction.connect("Interacted", interaction)
#	DialogueManager.connect("dialogue_started", interaction)
	DialogueManager.connect("dialogue_ended", interaction_ended)
	update_target_position()
	idle_Walking_timer.start(randomTime)
	
func _process(delta):
	velocity = Vector3.ZERO
	setGravity(delta)
	
	match state:
		IDLE:
			print_debug("walking")
			animPlayer.play("Idle")	
			await idle_Walking_timer.timeout
			state = WALKING
			print_debug("walking")

		WALKING:
			animPlayer.play("Walking")
			random_roaming()
			if nav_agent.is_navigation_finished():
				idle_Walking_timer.start(randomTime)
				update_target_position()
				state = IDLE
				print_debug("Idle")

		TALKING:
			look_at(player.global_transform.origin)
			animPlayer.play("Talking")
			if !interacted:
				update_target_position()
				idle_Walking_timer.start(randomTime)
				state = IDLE
				print_debug("Idle")
			
func setGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
func update_target_position():
	randomTime = randi_range(0, 20)
	if target_vector == last_target_vector:
		target_vector = Vector3(randi_range(-radius, radius),  0, randi_range(-radius, radius))

func random_roaming():
	last_target_vector = target_vector 
	nav_agent.set_target_position(target_vector)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(global_transform.origin + velocity)
	move_and_slide()

func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return (target_vector - global_position).length() < TOLERANCE

func interaction():
	interacted = true
	state = TALKING

func interaction_ended():
	interacted = false
		
	
