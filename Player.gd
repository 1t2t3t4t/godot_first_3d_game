extends CharacterBody3D

signal hit

@export_category("Movement")
@export var speed = 14
@export var fall_acceleration = 75

@export var jump_impulse = 20
@export var bounce_impulse = 16

@onready var anim := $AnimationPlayer as AnimationPlayer
@onready var pivot := $Pivot

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var forward = transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("move_right"):
		direction += right
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_back"):
		direction += forward
	if Input.is_action_pressed("move_forward"):
		direction -= forward

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.look_at(position + direction, Vector3.UP)
		anim.speed_scale = 4
	else:
		anim.speed_scale = 1

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_velocity.y = jump_impulse
		
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider() as Mob
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
	
	velocity = target_velocity
	move_and_slide()
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func _on_mob_detector_body_entered(body: Node3D) -> void:
	hit.emit()
	queue_free()
