extends HBoxContainer

var hearts: Array[TextureRect]
var max_hearts: int = GameState.player_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts.append($TextureRect)
	hearts.append($TextureRect2)
	hearts.append($TextureRect3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ii in range(max_hearts):
		if GameState.player_hp < max_hearts and ii >= GameState.player_hp:
			hearts[ii].texture = load("res://textures/heart_broken.png")
