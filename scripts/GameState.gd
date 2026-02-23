extends Node

enum GameScreenType{
	MENU, IN_GAME, GAME_OVER
}

var game_screen_type : GameScreenType = GameScreenType.MENU:
	get: return game_screen_type
	set(val):
		game_screen_type = val
		_update_ost()

var player_hp: int = Game.MAX_PLAYER_HP:
	get: return player_hp
	set(val): 
		player_hp = val
		_update_ost()
var player_hit_cooldown: float = 0.0
const PLAYER_HIT_COOLDOWN_SEC = 0.5

var is_player_dead : bool:
	get: return player_hp <= 0

var player_has_won: bool:
	get: return infected_points == infected_point_count and infected_point_count != 0
	set(_val):pass

var game_started: bool = false

var player_mask: int = 0  # bitmask of Game.Mask values (see Game.gd)

var infected_point_count: int = 0
var infected_points: int = 0:
	get: return infected_points
	set(val):
		infected_points = val
		if player_has_won:
			(NodeUtils.get_descendant_of_type(get_tree().root, WinEffect) as WinEffect).do_play()
		_update_ost()

func _update_ost()->void:
	var intensity := 0.0
	if game_screen_type == GameScreenType.MENU:
		intensity = 0.0
	elif game_screen_type == GameScreenType.GAME_OVER:
		intensity = 4.0
	elif game_screen_type == GameScreenType.IN_GAME:
		if player_hp <= 1 or infected_points >= 4:
			intensity = 3.0
		elif player_hp <= 2 or infected_points >= 2:
			intensity = 2.0
		else:
			intensity = 1.0
	
	print("OST Intensity: {0}".format([intensity]))
	SoundManager.SetSoundtrackIntensity(intensity)
	

func _process(delta: float) -> void:
	player_hit_cooldown = max(0.0, player_hit_cooldown - delta)
	
	
func find_player()->Player: return NodeUtils.get_descendant_of_type(get_tree().root, Player) as Player
func find_death_effect()->DeathEffect: return NodeUtils.get_descendant_of_type(get_tree().root, DeathEffect) as DeathEffect
	
func player_hit() -> void:
	if player_has_won:
		return
	
	if is_player_dead: 
		return
	if player_hit_cooldown > 0.0:
		return
	
	
	player_hp -= 1;
	player_hit_cooldown = GameState.PLAYER_HIT_COOLDOWN_SEC
	
	
	var player := find_player()
	if player:
		player.do_hurth_effect()
		if (GameState.player_mask != 0):
			player.change_mask(GameState.player_mask)
	if player_hp <= 0:
		print("ur ded")
		var death_effect:= find_death_effect()
		if death_effect: death_effect.do_start()
		var anim = player.find_child("AnimatedSprite2D")
		if anim is AnimatedSprite2D:
			(anim as AnimatedSprite2D).stop()

func player_gain_hp() -> void:
	return
	#if player_hp < Game.MAX_PLAYER_HP:
	#	player_hp += 1;
