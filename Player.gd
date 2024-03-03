extends CharacterBody3D

const SPEED = 10
const ACC = 0.3
const JUMP_VELOCITY = 4.5
const SENSITIVITY_SCALE = 0.01

signal RightControls
signal LeftControls

@export var TURN_SPEED = .1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

var rFootRaised := false
var lFootRaised := false

var rGrab := false
var lGrab := false

var rInputDir := Vector2.ZERO
var lInputDir := Vector2.ZERO

func _process(delta):
	rFootRaised = (Input.is_action_pressed("R2") and !lFootRaised)
	lFootRaised = (Input.is_action_pressed("L2") and !rFootRaised)
		
	rGrab = Input.is_action_pressed("R1")
	lGrab = Input.is_action_pressed("L1")
		
	lInputDir = Input.get_vector("LLeft", "LRight", "LUp", "LDown")
	rInputDir = Input.get_vector("RLeft", "RRight", "RUp", "RDown")

@onready var leftFoot := $"Feet/Left Foot"
@onready var rightFoot := $"Feet/Right Foot"
@onready var leftHand := $"Hands/Left Hand"
@onready var rightHand := $"Hands/Right Hand"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	emit_signal("LeftControls", lInputDir, lFootRaised, lGrab)
	emit_signal("RightControls", rInputDir, rFootRaised, rGrab)
	if Input.is_action_pressed("DLeft"):
		RotateBodyParts(TURN_SPEED)
	if Input.is_action_pressed("DRight"):
		RotateBodyParts(-TURN_SPEED)
		
	MoveBodyParts()
	move_and_slide()

func RotateBodyParts(speed):
	self.rotate_y(speed)
	leftFoot.rotate_y(speed)
	rightFoot.rotate_y(speed)
	#leftHand.rotate_y(speed)
	#rightHand.rotate_y(speed)

func MoveBodyParts():
	# Position body based on the average foot position
	position.x = (leftFoot.position.x + rightFoot.position.x) / 2
	position.z = (leftFoot.position.z + rightFoot.position.z) / 2

func _input(event):
	if event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			get_tree().quit()
