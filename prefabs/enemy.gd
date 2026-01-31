extends RigidBody2D

# if nonzero = moving towards the player
var attack_dir: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if attack_dir.length_squared() > 0:
		apply_central_impulse(500.0 * attack_dir)
		attack_dir = Vector2.ZERO
	pass

func _draw() -> void:
	draw_arc($PlayerDamageArea.position,
			$PlayerDetectArea/CollisionShape2D.shape.radius,
			0, TAU, 32, Color.WHITE)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if NodeUtils.get_ancestor_of_type(body, Player):
		attack_dir = (body.global_position - self.position).normalized()
	pass # Replace with function body.
