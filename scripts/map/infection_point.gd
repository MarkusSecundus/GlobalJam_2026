extends Node2D

@export var time_to_infect_sec: float = 5
@export var progress_loss_sec: float = 2

var is_player_inside: bool = false
var is_infected: bool = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var infection_sprite: Sprite2D = $Sprite2D

var HINT_DISTANCE: int = 1000

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InfectionSingleton.infected_point_count += 1
	player = get_tree().root.get_node("Node2D/Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_distance = player.global_position.distance_to(self.global_position)
	
	if player_distance < HINT_DISTANCE:
		#print("amogus")
		pass
	
	if (is_infected):
		return
	
	if (is_player_inside):
		progress_bar.value += (100 * delta) / time_to_infect_sec
	else:
		progress_bar.value -= (100 * delta) / progress_loss_sec
		
	if progress_bar.value >= 100 and not is_infected:
		is_infected = true
		InfectionSingleton.infected_points += 1
		progress_bar.hide()
		infection_sprite.scale.y *= -1
		# Change sprite here????

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = false
