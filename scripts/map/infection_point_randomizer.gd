extends Node

@export var total_infection_points_count : int = 5

func _ready() -> void:
	do_randomize()

func do_randomize()->void:
	var total_infection_points :Array= NodeUtils.get_descendants_of_type(get_tree().root, InfectionPoint)
	while total_infection_points.size() > total_infection_points_count:
		var idx := randi_range(0, total_infection_points.size() - 1)	
		var to_delete := (total_infection_points[idx] as InfectionPoint)
		to_delete.get_parent().remove_child.call_deferred(to_delete)
		to_delete.queue_free()
		total_infection_points.remove_at(idx)
