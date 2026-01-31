extends Control

var player: Player

var close_infection_points: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().root.get_node("Node2D/Player")
	for child_it in get_children():
			child_it.visible = false

func sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var a_dist: float = a.global_position.distance_to(player.global_position)
	var b_dist: float = b.global_position.distance_to(player.global_position)
	
	if (a_dist < b_dist):
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if close_infection_points.size() == 0:
		for child_it in get_children():
			child_it.visible = false
		
		return
	
	var center = size / 2
	
	close_infection_points.sort_custom(sort_by_distance)
	
	var closest_infection_point: Node2D = close_infection_points[0]
	var closest_infection_point_dir = closest_infection_point.global_position - player.global_position
	
	if (closest_infection_point.global_position.distance_to(player.global_position) < 700):
		for child_it in get_children():
			child_it.visible = false
		
		return
	
	for child_it in get_children():
		var angle = closest_infection_point_dir.angle_to(child_it.position - center)
		
		if (rad_to_deg(angle) < 25 and rad_to_deg(angle) > -25):
			child_it.visible = true
		else:
			child_it.visible = false
		pass
	pass
