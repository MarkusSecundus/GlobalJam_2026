class_name Player
extends RigidBody2D

const PLAYER_SPEED_SLOW: float = 500
const PLAYER_SPEED_FAST: float = 670

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

func change_mask(new_mask: int) -> void:
	assert(new_mask == Game.Mask.TRI or new_mask == Game.Mask.SQUARE or new_mask == Game.Mask.CIRCLE)
	
	if GameState.player_mask == new_mask:
		GameState.player_mask = 0
	else:
		GameState.player_mask = new_mask
	
	$Mask/Tri.visible    = GameState.player_mask & Game.Mask.TRI
	$Mask/Square.visible = GameState.player_mask & Game.Mask.SQUARE
	$Mask/Circle.visible = GameState.player_mask & Game.Mask.CIRCLE
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mask1"):
		change_mask(Game.Mask.TRI)
	if Input.is_action_just_pressed("Mask2"):
		change_mask(Game.Mask.SQUARE)
	if Input.is_action_just_pressed("Mask3"):
		change_mask(Game.Mask.CIRCLE)

func _physics_process(delta: float) -> void:
	var direction:= Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		direction[1] -= 1
	if Input.is_action_pressed("Down"):
		direction[1] += 1
	if Input.is_action_pressed("Left"):
		direction[0] -= 1
	if Input.is_action_pressed("Right"):
		direction[0] += 1
	
	if direction.length_squared() > 0.01:
		direction = direction.normalized()
	
	
	if GameState.player_mask == 0:
		direction *= PLAYER_SPEED_FAST
	else:
		direction *= PLAYER_SPEED_SLOW
	
	linear_velocity = linear_velocity.lerp(direction, sqrt(delta))

func do_hurth_effect()->void:
	$Camera2D/AnimationPlayer.play("player_hit_screenshake")
