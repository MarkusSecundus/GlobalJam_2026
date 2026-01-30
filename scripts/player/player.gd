extends RigidBody2D

var PLAYER_SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw():
	#draw_circle(self.offset, 100.0, Color.RED, false)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#var direction:= Vector2.ZERO
	#
	#if Input.is_key_pressed(KEY_W):
		#direction[1] -= 1
	#if Input.is_key_pressed(KEY_S):
		#direction[1] += 1
	#if Input.is_key_pressed(KEY_A):
		#direction[0] -= 1
	#if Input.is_key_pressed(KEY_D):
		#direction[0] += 1
	#
	#direction *= PLAYER_SPEED
	#
	#var amongus := direction - linear_velocity
	#amongus = amongus.normalized() * PLAYER_SPEED
	#
	#apply_force(amongus)

func _physics_process(delta: float) -> void:
	var direction:= Vector2.ZERO
	
	if Input.is_key_pressed(KEY_W):
		direction[1] -= 1
	if Input.is_key_pressed(KEY_S):
		direction[1] += 1
	if Input.is_key_pressed(KEY_A):
		direction[0] -= 1
	if Input.is_key_pressed(KEY_D):
		direction[0] += 1
	
	if Input.is_key_pressed(KEY_UP):
		direction[1] -= 1
	if Input.is_key_pressed(KEY_DOWN):
		direction[1] += 1
	if Input.is_key_pressed(KEY_LEFT):
		direction[0] -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		direction[0] += 1
	
	direction *= PLAYER_SPEED
	
	linear_velocity = linear_velocity.lerp(direction, sqrt(delta))
