extends ColorRect

class_name Retry

@onready var anim := $"../AnimationPlayer" as AnimationPlayer

func play_show_anim() -> void:
	anim.play("show_retry")
