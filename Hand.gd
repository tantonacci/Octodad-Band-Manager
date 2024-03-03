extends CharacterBody3D

@export var Hand := hand.Left
@onready var player = $".."

@onready var basePos = position
@onready var handCollider = $"../Left Hand/LeftHandRay" if Hand == hand.Left else $"../Right Hand/RightHandRay"
@onready var handInteractNode = $"../Left Hand/Interact Node" if Hand == hand.Left else $"../Right Hand/Interact Node"
var isHoldingObject = false
var heldObject = null

const REACH = 2
const ACC = 0.3
const SPEED = 2
const GRAB_DISTANCE = .6

enum hand {
	Left,
	Right
}

var direction

func MoveHand(dir, lockHand, grab):
	if !lockHand:
		direction = (transform.basis * Vector3(dir.x, -dir.y, 0))
	else:
		direction = Vector3(0,0,0)
	pass
	if grab:
		position.z = basePos.z - GRAB_DISTANCE
		grabObject()
	else:
		position.z = basePos.z
		isHoldingObject = false
		heldObject = null

func _physics_process(delta):
	#if direction:
		#velocity.x = move_toward(velocity.x, direction.x * SPEED, ACC)
		##velocity.z = move_toward(velocity.z, direction.z * SPEED, ACC)
		#velocity.y = move_toward(velocity.y, direction.y * SPEED, ACC)
	#else:
		#velocity.x = move_toward(velocity.x, 0, ACC)
		##velocity.z = move_toward(velocity.z, 0, ACC)
		#velocity.y = move_toward(velocity.y, 0, ACC)
	
	position.x = basePos.x + (direction.x * REACH)
	position.y = basePos.y + (direction.y * REACH)
	
	move_and_slide()
	maintainInteraction()
	
func grabObject():
	if !isHoldingObject:
		handCollider.force_raycast_update()
		if handCollider.is_colliding():
			var obj = handCollider.get_collider()
			if obj.is_in_group("Interactable"):
				isHoldingObject = true
				heldObject = obj

func maintainInteraction():
	if isHoldingObject and heldObject != null:
		var forceDirection = handInteractNode.global_transform.origin - heldObject.global_transform.origin
		forceDirection = forceDirection.normalized()
		
		heldObject.apply_central_force(forceDirection * 5)




