extends CharacterBody2D


@export var JUMP_VELOCITY = -500.0
@export var SPEED = 300.0
@export var max_player_distance := 950  #max distance from other player
@export var other_player: Node2D
@onready var sprite = $AnimatedSprite2D
@onready var frog_sound = $Ribbit
@onready var respawn_position: Vector2 = global_position

	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var collision = get_slide_collision(0) #ensures player stays on moving platforms
		if collision:
			var collider = collision.get_collider()
			if collider is CharacterBody2D and collider.name == "MovingPlatform":
				velocity.x += collider.velocity.x
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		frog_sound.play()
		sprite.play("jump")

	var direction := Input.get_axis("move_leftp1", "move_rightp1")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if is_on_floor() and sprite.animation != "move_right":
			sprite.play("move_right")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and sprite.animation != "idle":
			sprite.play("idle")
	if not is_on_floor():
		if velocity.y < 0 and sprite.animation != "jump":
			sprite.play("jump")
		elif velocity.y > 0 and sprite.animation != "fall":
			sprite.play("fall")

#check if distance from other player exceeds maximum distance then stops movement if it does
	var next_position = global_position + Vector2(direction * SPEED * delta, 0)
	var distance = next_position.distance_to(other_player.global_position)

	if distance <= max_player_distance:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	if is_on_floor():
		respawn_position = global_position #update last position for respawning
		check_platform_collision()
			
	move_and_slide()

#prevent errors with moving platform by checking collisions
func check_platform_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			if collider is CharacterBody2D and collider.name == "MovingPlatform":
				velocity.x += collider.velocity.x
