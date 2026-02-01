class_name Player
extends RigidBody2D

const PLAYER_SPEED_SLOW: float = 450
const PLAYER_SPEED_FAST: float = 670

var zoom_t = 0.0
var zoom_t_target = 0.0

#var moving_via_input: bool = false

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
	
	$mask_change_anim.visible = true
	$mask_change_anim.play()
	
	$Mask.visible            = GameState.player_mask != 0
	$MaskShapeTri.visible    = GameState.player_mask & Game.Mask.TRI
	$MaskShapeSquare.visible = GameState.player_mask & Game.Mask.SQUARE
	$MaskShapeCircle.visible = GameState.player_mask & Game.Mask.CIRCLE
	

func _process(delta: float) -> void:
	if !GameState.is_player_dead:
		if Input.is_action_just_pressed("Mask1"):
			change_mask(Game.Mask.TRI)
		if Input.is_action_just_pressed("Mask2"):
			change_mask(Game.Mask.SQUARE)
		if Input.is_action_just_pressed("Mask3"):
			change_mask(Game.Mask.CIRCLE)

		#if moving_via_input:
		#	_anim.play("move")
		#else:
		#	_anim.play("idle")
	
	const SPEED = 1.0/0.5
	if zoom_t < zoom_t_target:
		zoom_t = min(zoom_t + SPEED * delta, zoom_t_target)
	elif zoom_t > zoom_t_target:
		zoom_t = max(zoom_t - SPEED * delta, zoom_t_target)
		
	var zoom: float = 0.32 + 0.15 * ease(zoom_t, -2.5)
	$Camera2D.zoom = Vector2(zoom, zoom)

func _physics_process(delta: float) -> void:
	if GameState.is_player_dead:
		return
	
	if GameState.player_has_won:
		return;
		
	var target_facing_vec := get_global_mouse_position() - self.global_position
	if target_facing_vec.length_squared() > 1.0:
		# this is bad and stupid, but i can't do math rn
		var rot_vec := Vector2.from_angle(self.rotation).orthogonal()
		var angle_to_mouse := rot_vec.angle_to(target_facing_vec)
		var target_rotation := rotation + angle_to_mouse
	
		var rot_speed_t: float = clamp(inverse_lerp(0.05 * PI, 0.9*PI, abs(angle_to_mouse)), 0.0, 1.0)
		var rot_speed: float = lerp(2.5, 5.5, rot_speed_t)
		rotation = rotate_toward(rotation, target_rotation, rot_speed * delta)
	
	if Input.is_action_pressed("MouseLeft"):
		var force_dir := Vector2.from_angle(self.rotation).orthogonal()
		var force_amount: float = 7067.0
		if GameState.player_mask != 0:
			force_amount = 4000.0
		apply_central_force(force_amount * force_dir)
	else:
		apply_central_force(Vector2.ZERO)
		
	#moving_via_input = false
	
	if GameState.player_mask == 0:
		zoom_t_target = 0.0
	else:
		zoom_t_target = 1.0
	
	# This is actually load-bearing code that makes the movement feel like
	# ... well like it feels and what we've been "balancing" for,
	# so it is what it is.
	linear_velocity = linear_velocity.lerp(Vector2.ZERO, sqrt(delta))

func do_hurth_effect()->void:
	$Camera2D/AnimationPlayer.play("player_hit_screenshake")
	$Sounds/BeingHit.play()


func _on_mask_change_anim_animation_finished() -> void:
	$mask_change_anim.visible = false
