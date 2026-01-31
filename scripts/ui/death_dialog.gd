class_name DeathEffect
extends CanvasItem

func _ready() -> void:
	self.visible = false

func do_start()->void:
	self.visible = true
	$AnimationPlayer.play("death_effect")
