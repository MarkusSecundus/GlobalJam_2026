class_name DeathEffect
extends CanvasItem

@export var do_play_btn:bool:
	set(_val):
		do_start()

func _ready() -> void:
	self.visible = false

func do_start()->void:
	self.visible = true
	$AnimationPlayer.play("death_effect")
