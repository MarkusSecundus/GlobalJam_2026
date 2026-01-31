extends RigidBody2D

# if nonzero = moving towards the player
var attack_dir: Vector2 = Vector2.ZERO

# 0 to 1.0 - full aggro
var aggro_level: float = 0.0
var detected_player: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if attack_dir.length_squared() > 0:
		apply_central_impulse(-self.linear_velocity) # kill any velocity we had
		apply_central_impulse(1000.0 * attack_dir)
		attack_dir = Vector2.ZERO
	pass

func _draw() -> void:
	var col = lerp(Color.WHITE, Color.DEEP_PINK, aggro_level)
	draw_arc($PlayerDamageArea.position,
			$PlayerDetectArea/CollisionShape2D.shape.radius,
			0, TAU, 32, col)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var initial_aggro_level = aggro_level
	if detected_player:
		aggro_level += 1.0 * delta
	else:
		aggro_level -= 0.5 * delta
	aggro_level = clampf(aggro_level, 0.0, 1.0)
	
	if aggro_level != initial_aggro_level:
		queue_redraw()
	
	# detected_player should always be there, but just in case
	if detected_player and aggro_level >= 1.0:
		attack_dir = (detected_player.global_position - self.position).normalized()
		aggro_level = 0.0
		


func _on_player_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	# do I need to use Jakub's helper?
	# if NodeUtils.get_ancestor_of_type(body, Player):
	if body is Player:
		detected_player = body


func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		detected_player = null
