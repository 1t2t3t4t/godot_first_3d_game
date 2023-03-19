extends CharacterBody3D

class_name Mob

signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

func initialize(start_position: Vector3, player_position: Vector3):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	rotation.x = 0
	
	var random_speed := randi_range(min_speed, max_speed)
	velocity = -transform.basis.z * random_speed
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _physics_process(_delta):
	move_and_slide()
	
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash():
	squashed.emit()
	queue_free()
