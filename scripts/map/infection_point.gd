class_name InfectionPoint
extends Node2D

@export var time_to_infect_sec: float = 5
@export var progress_loss_sec: float = 2

var is_player_inside: bool = false
var is_infected: bool = false
var is_player_inside_hint: bool = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var infection_sprite: Sprite2D = $Sprite2D

var player: Player
var hint_compass: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.infected_point_count += 1
	player = NodeUtils.get_descendant_of_type(get_tree().root, Player )
	hint_compass = get_tree().root.get_node("Node2D/CanvasLayer2/Control")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_distance = player.global_position.distance_to(self.global_position)
	
	if is_player_inside_hint:
		if hint_compass.number_of_close_infection_points == 1:
			hint_compass.closest_infection_point_dir = global_position - player.global_position
			hint_compass.distance_to_closest_infection_point = player_distance
		else:
			if player_distance < hint_compass.distance_to_closest_infection_point:
				hint_compass.closest_infection_point_dir = global_position - player.global_position
				hint_compass.distance_to_closest_infection_point = player_distance
	
	if (is_infected):
		return
	
	var color: Color
	
	if (is_player_inside):
		progress_bar.value += (100 * delta) / time_to_infect_sec
		color = Color.DARK_TURQUOISE
	else:
		progress_bar.value -= (100 * delta) / progress_loss_sec
		color = Color.ORANGE_RED
	
	progress_bar.modulate = lerp(progress_bar.modulate, color, sqrt(delta))
	
	if progress_bar.value >= 100 and not is_infected:
		is_infected = true
		hint_compass.close_infection_points.erase(self)
		GameState.infected_points += 1
		GameState.player_gain_hp()
		progress_bar.hide()
		infection_sprite.scale.y *= -1
		# Change sprite here????

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = false

func _on_area_2d_hint_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		if not is_infected:
			hint_compass.close_infection_points.append(self)


func _on_area_2d_hint_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		if not hint_compass.close_infection_points.has(self):
			hint_compass.close_infection_points.erase(self)
