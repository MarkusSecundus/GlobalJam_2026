extends RigidBody2D

var ATTACK_IMPULSE = 1000.0
var ATTACK_DIR_VARIABILITY = 300.0
var AGGRO_GAIN_SPEED = 1.0
var AGGRO_LOSE_SPEED = 0.5
var AGGRO_COOLDOWN_AFTER_ATTACK = 0.075
var AGGRO_COOLDOWN_AFTER_HIT = 0.467

# if nonzero = moving towards the player
var attack_dir: Vector2 = Vector2.ZERO

@export_flags("Tri", "Rect", "Circle") # must match Game.gd Mask enum
var detectable_shapes: int = 0

# 0 to 1.0 - full aggro
var aggro_level: float = 0.0
var aggro_cooldown: float = 0.0
var detected_player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !(detectable_shapes & Game.Mask.TRI):
		$ShapeIndicators/Tri.visible = false
	if !(detectable_shapes & Game.Mask.SQUARE):
		$ShapeIndicators/Square.visible = false
	if !(detectable_shapes & Game.Mask.CIRCLE):
		$ShapeIndicators/Circle.visible = false

func _physics_process(delta: float) -> void:
	if attack_dir.length_squared() > 0:
		apply_central_impulse(-self.linear_velocity) # kill any velocity we had
		apply_central_impulse(ATTACK_IMPULSE * attack_dir)
		
		if detected_player is RigidBody2D: # paranoid null check
			# add player velocity for "smartness"
			# but add additional perpendicular element so that it's not perfect
			var imp = (detected_player as RigidBody2D).linear_velocity
			imp += attack_dir.orthogonal() * randf_range(-1.0, 1.0) * ATTACK_DIR_VARIABILITY
			apply_central_impulse(imp)
		
		apply_torque_impulse(10000.0)
		
		attack_dir = Vector2.ZERO
	pass

func _draw() -> void:
	var col = lerp(Color.WHITE, Color.DEEP_PINK, aggro_level)
	if aggro_cooldown > 0.0:
		col = Color.CORNFLOWER_BLUE
	draw_arc($PlayerDetectArea.position,
			$PlayerDetectArea/CollisionShape2D.shape.radius,
			0, TAU, 32, col)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var initial_aggro_level = aggro_level
	
	if aggro_cooldown > 0:
		aggro_cooldown = max(0.0, aggro_cooldown - delta)
	
	if detected_player and aggro_cooldown == 0.0:
		aggro_level += AGGRO_GAIN_SPEED * delta
	else:
		aggro_level -= AGGRO_LOSE_SPEED * delta
	aggro_level = clampf(aggro_level, 0.0, 1.0)
	
	if aggro_level != initial_aggro_level:
		queue_redraw()
	
	# detected_player should always be there, but just in case
	if detected_player and aggro_level >= 1.0:
		attack_dir = (detected_player.global_position - self.position).normalized()
		aggro_level = 0.0
		aggro_cooldown = AGGRO_COOLDOWN_AFTER_ATTACK


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	# do I need to use Jakub's helper?
	# if NodeUtils.get_ancestor_of_type(body, Player):
	if body is Player:
		detected_player = body


func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		detected_player = null


func _on_body_entered(body: Node) -> void:
	if body is Player:
		aggro_cooldown = AGGRO_COOLDOWN_AFTER_HIT
		GameState.player_hit()
