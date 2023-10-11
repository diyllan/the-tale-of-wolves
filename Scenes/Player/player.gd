extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isPaused = false
var dialogueActive = false
var hiding = false
var leaveHiding = false

var hidingPos
var xMaxRotation = 60
var xMinRotation = -60
var yMaxRotation = 360
var yMinRotation = -360
var currentCamPosHiding

#define camera-movement objects
@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var camera_anim_play = $Neck/Camera3D/AnimationPlayer
@onready var anim_play = $LittleRedCapAnim/AnimationPlayer
@onready  var model = $LittleRedCapAnim

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("Pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			
			self.rotation.y = clamp(self.rotation.y, deg_to_rad(yMinRotation), deg_to_rad(yMaxRotation))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(xMinRotation), deg_to_rad(xMaxRotation))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
	if direction != Vector3():
		anim_play.play("Walking")
		camera_anim_play.play("Head Bob")

	playerHide()
	
func playerHide():
	if hiding:
		model.hide()
		var HidingTween = create_tween()
		HidingTween.tween_property(self, "global_position", hidingPos.global_position, 0.2)
#		HidingTween.chain().tween_property(self, "global_rotation", hidingPos.global_rotation, 0.2)
		print(currentCamPosHiding)
		camera.fov = 45
		xMaxRotation = 30
		xMinRotation = -30

	if hiding and Input.is_action_just_pressed("interact"):
		print(self.global_rotation)
		print("hiding and interacting")
		hiding = false
		var LeavingTween = create_tween()
		LeavingTween.tween_property(self, "global_position", currentCamPosHiding, 0.5)
#		LeavingTween.chain().tween_property(self, "global_rotation", currentCamPosHiding.global_rotation, 0.5)
		xMaxRotation = 60
		xMinRotation = -60
		yMaxRotation = 360
		yMinRotation = -360
		camera.fov = 75
