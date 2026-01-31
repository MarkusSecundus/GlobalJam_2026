extends Node

var player_hp: int = 5
var player_hit_cooldown: float = 0.0
const PLAYER_HIT_COOLDOWN_SEC = 0.5

var player_shape: int = 0  # bitmask of Game.Mask values (see Game.gd)

var infected_point_count: int = 0
var infected_points: int = 0

func _process(delta: float) -> void:
	player_hit_cooldown = max(0.0, player_hit_cooldown - delta)
	
func player_hit() -> void:
	if player_hit_cooldown > 0.0:
		return
	
	player_hp -= 1;
	player_hit_cooldown = GameState.PLAYER_HIT_COOLDOWN_SEC
	
	if player_hp <= 0:
		print("ur ded")
