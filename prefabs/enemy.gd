extends RigidBody2D

var ATTACK_IMPULSE_MAGNITUDE = 1000.0
var ATTACK_DIR_VARIABILITY = 300.0
var AGGRO_GAIN_SPEED_SLOW = 1.0/3.67
var AGGRO_GAIN_SPEED_FAST = 1.0/0.5
var AGGRO_LOSE_SPEED = 1.0 / 2.0
var AGGRO_COOLDOWN_AFTER_ATTACK = 0.1
var AGGRO_COOLDOWN_AFTER_HIT = 1.67

const RANDOM_MOVE_PERIOD_MIN: float = 0.15
const RANDOM_MOVE_PERIOD_MAX: float = 2.0
var random_move_timeout: float = 0.0

const RANDOM_MOVE_MAGNITUDE_MIN: float = 300.0
const RANDOM_MOVE_MAGNITUDE_MAX: float = 500.0
var random_move_impulse: Vector2 = Vector2.ZERO

# if nonzero = moving towards the player
var attack_dir: Vector2 = Vector2.ZERO

var detectable_shapes: int = 0

# 0 to 1.0 - full aggro
var aggro_level: float = 0.0
var aggro_cooldown: float = 0.0
var detected_player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, GameState.infected_point_count) < GameState.infected_points + 1:
		detectable_shapes |= Game.Mask.TRI
	
	if randi_range(0, GameState.infected_point_count) < GameState.infected_points + 1:
		detectable_shapes |= Game.Mask.SQUARE
	
	if randi_range(0, GameState.infected_point_count) < GameState.infected_points + 1:
		detectable_shapes |= Game.Mask.CIRCLE
	
	if !(detectable_shapes & Game.Mask.TRI):
		$ShapeIndicators/Tri.visible = false
	if !(detectable_shapes & Game.Mask.SQUARE):
		$ShapeIndicators/Square.visible = false
	if !(detectable_shapes & Game.Mask.CIRCLE):
		$ShapeIndicators/Circle.visible = false

func _physics_process(delta: float) -> void:
	if attack_dir.length_squared() > 0:
		apply_central_impulse(-self.linear_velocity) # kill any velocity we had
		apply_central_impulse(ATTACK_IMPULSE_MAGNITUDE * attack_dir)
		
		if detected_player is RigidBody2D: # paranoid null check
			# add player velocity for "smartness"
			# but add additional perpendicular element so that it's not perfect
			var imp: Vector2 = (detected_player as RigidBody2D).linear_velocity
			imp += attack_dir.orthogonal() * randf_range(-1.0, 1.0) * ATTACK_DIR_VARIABILITY
			apply_central_impulse(imp)
		
		apply_torque_impulse(10000.0)
		
		attack_dir = Vector2.ZERO
	
	if random_move_impulse.length_squared() > 0.0:
		apply_impulse(random_move_impulse)
		apply_torque_impulse(-3000.0)
		random_move_impulse = Vector2.ZERO
		pass

func _draw() -> void:
	var col: Color = lerp(Color.WHITE, Color.DEEP_PINK, aggro_level)
	draw_arc($PlayerDetectArea.position,
			$PlayerDetectArea/CollisionShape2D.shape.radius,
			0, TAU, 32, col)

func maybe_do_random_movement(dt: float) -> void:
	random_move_timeout -= dt
	
	if random_move_timeout <= 0.0:
		random_move_timeout += randf_range(RANDOM_MOVE_PERIOD_MIN, RANDOM_MOVE_PERIOD_MAX)
		
		var magnitude = randf_range(RANDOM_MOVE_MAGNITUDE_MIN, RANDOM_MOVE_MAGNITUDE_MAX)
		
		if detected_player: # make the random movement more subtle when the player is in area
			magnitude *= 0.25
		
		var dir: Vector2 = (self.linear_velocity.normalized() + 0.95 * Vector2.from_angle(randf_range(0.0, TAU))).normalized()
		random_move_impulse = magnitude * dir

func get_aggro_gain_speed() -> float:
	if GameState.player_mask == 0:
		return AGGRO_GAIN_SPEED_FAST
	if detectable_shapes & GameState.player_mask:
		return AGGRO_GAIN_SPEED_FAST
	return AGGRO_GAIN_SPEED_SLOW

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var initial_aggro_level = aggro_level
	
	if aggro_cooldown > 0:
		aggro_cooldown = max(0.0, aggro_cooldown - delta)
	
	if detected_player and aggro_cooldown <= 0.0 and !GameState.player_has_won:
		aggro_level += get_aggro_gain_speed() * delta
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
	
	maybe_do_random_movement(delta)


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
		$Sounds/Hit.play()
