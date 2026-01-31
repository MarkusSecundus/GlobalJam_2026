extends HBoxContainer

@onready var max_hearts: int = GameState.player_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rect :TextureRect= $TextureRect
	for i in max_hearts - 1:
		NodeUtils.instantiate_child_by_clone_ingame(self, rect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ii in range(max_hearts):
		if GameState.player_hp < max_hearts and ii >= GameState.player_hp:
			var heart :TextureRect = self.get_child(ii) as TextureRect
			heart.texture = load("res://textures/heart_broken.png")
