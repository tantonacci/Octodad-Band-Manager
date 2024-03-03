extends CharacterBody3D

@export var Foot := foot.Left
@onready var player = $".."

const REACH = 3
const ACC = 0.3
const SPEED = 4

enum foot {
	Left,
	Right
}

var direction

func MoveFoot(dir, raiseFoot, grab):
	if raiseFoot:
		position.y = 0.2
		direction = (transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	else:
		position.y = 0.1
		direction = Vector3(0,0,0)
	pass

func _physics_process(delta):
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACC)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACC)
	else:
		velocity.x = move_toward(velocity.x, 0, ACC)
		velocity.z = move_toward(velocity.z, 0, ACC)
	
	move_and_slide()
