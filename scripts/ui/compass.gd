extends Control

var player: Player

var close_infection_points: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().root.get_node("Node2D/Player")
	for child_it in get_children():
			child_it.modulate.a = 0.0

func sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var a_dist: float = a.global_position.distance_to(player.global_position)
	var b_dist: float = b.global_position.distance_to(player.global_position)
	
	if (a_dist < b_dist):
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var wish_alphas: Array[float]
	wish_alphas.resize(get_children().size())
	
	if close_infection_points.size() == 0:
		for ii in get_children().size():
			wish_alphas[ii] = 0.0
	else:
		var center = size / 2
		close_infection_points.sort_custom(sort_by_distance)
		var closest_infection_point: Node2D = close_infection_points[0]
		var closest_infection_point_dir = closest_infection_point.global_position - player.global_position
		var closest_infection_point_dist = closest_infection_point.global_position.distance_to(player.global_position)
		
		if (closest_infection_point.global_position.distance_to(player.global_position) < 300):
			for ii in get_children().size():
				wish_alphas[ii] = 0.0
		else:
			for ii in get_children().size():
				var child_it: AnimatedSprite2D = get_children()[ii]
				var angle = closest_infection_point_dir.angle_to(child_it.position - center)
				
				if (rad_to_deg(angle) < 25 and rad_to_deg(angle) > -25):
					wish_alphas[ii] = clamp(1 - closest_infection_point_dist / 2700, 0, 1)
				else:
					wish_alphas[ii] = 0.0
	
	for ii in get_children().size():
		var child_it: AnimatedSprite2D = get_children()[ii]
		if wish_alphas[ii] > 0.0:
			child_it.modulate.a = 0.5
		else:
			child_it.modulate.a = 0.0
			#wish_alphas[ii] += sin((Time.get_ticks_msec() + ii * 1234) / 1000.0) / 10
		
		wish_alphas[ii] = clamp(wish_alphas[ii], 0, 1)
		
		# God this is so stupid
		#child_it.modulate.a = lerp(child_it.modulate.a, wish_alphas[ii], sqrt(delta))
		#child_it.scale.y = 0.4 + sin((Time.get_ticks_msec() + ii * 1234) / 1000.0) / 30
