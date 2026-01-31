class_name Player
extends RigidBody2D

const PLAYER_SPEED_SLOW: float = 450
const PLAYER_SPEED_FAST: float = 670

var zoom_t = 0.0
var zoom_t_target = 0.0

var moving_via_input: bool = false

@onready var _anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_anim.play("idle")
	
func _draw():
	#draw_circle(self.offset, 100.0, Color.RED, false)
	pass

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
	if !GameState.is_player_dead:
		if Input.is_action_just_pressed("Mask1"):
			change_mask(Game.Mask.TRI)
		if Input.is_action_just_pressed("Mask2"):
			change_mask(Game.Mask.SQUARE)
		if Input.is_action_just_pressed("Mask3"):
			change_mask(Game.Mask.CIRCLE)
		
		if moving_via_input:
			_anim.play("move")
		else:
			_anim.play("idle")
	
	const SPEED = 1.0/0.5
	if zoom_t < zoom_t_target:
		zoom_t = min(zoom_t + SPEED * delta, zoom_t_target)
	elif zoom_t > zoom_t_target:
		zoom_t = max(zoom_t - SPEED * delta, zoom_t_target)
		
	var zoom: float = 0.4 + 0.1 * ease(zoom_t, -2.5)
	$Camera2D.zoom = Vector2(zoom, zoom)

func _physics_process(delta: float) -> void:
	if GameState.is_player_dead:
		return
	
	if GameState.player_has_won:
		return;
		
	var direction:= Vector2.ZERO
	
	moving_via_input = false
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
		moving_via_input = true
	
	if GameState.player_mask == 0:
		direction *= PLAYER_SPEED_FAST
		zoom_t_target = 0.0
	else:
		direction *= PLAYER_SPEED_SLOW
		zoom_t_target = 1.0
	
	linear_velocity = linear_velocity.lerp(direction, sqrt(delta))

func do_hurth_effect()->void:
	$Camera2D/AnimationPlayer.play("player_hit_screenshake")
	$Sounds/BeingHit.play()
