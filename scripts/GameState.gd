extends Node

var player_hp: int = Game.MAX_PLAYER_HP
var player_hit_cooldown: float = 0.0
const PLAYER_HIT_COOLDOWN_SEC = 0.5

var player_mask: int = 0  # bitmask of Game.Mask values (see Game.gd)

var infected_point_count: int = 0
var infected_points: int = 0

func _process(delta: float) -> void:
	player_hit_cooldown = max(0.0, player_hit_cooldown - delta)
	
	
func find_player()->Player: return NodeUtils.get_descendant_of_type(get_tree().root, Player) as Player
func find_death_effect()->DeathEffect: return NodeUtils.get_descendant_of_type(get_tree().root, DeathEffect) as DeathEffect
	
func player_hit() -> void:
	if player_hit_cooldown > 0.0:
		return
	
	
	player_hp -= 1;
	player_hit_cooldown = GameState.PLAYER_HIT_COOLDOWN_SEC
	
	
	if player_hp <= 0:
		print("ur ded")
		var death_effect:= find_death_effect()
		if death_effect: death_effect.do_start()
	else:
		var player := find_player()
		if player: player.do_hurth_effect()

func player_gain_hp() -> void:
	if player_hp < Game.MAX_PLAYER_HP:
		player_hp += 1;
