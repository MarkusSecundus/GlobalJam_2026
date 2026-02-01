extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rect :TextureRect= $TextureRect
	for i in Game.MAX_PLAYER_HP - 1:
		NodeUtils.instantiate_child_by_clone_ingame(self, rect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ii in range(Game.MAX_PLAYER_HP):
		var heart :TextureRect = self.get_child(ii) as TextureRect
		if ii < GameState.player_hp:
			heart.texture = preload("res://textures/life.webp")
		else:
			heart.texture = preload("res://textures/no_lie.webp")
