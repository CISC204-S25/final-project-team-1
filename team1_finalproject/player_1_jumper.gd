extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var sprite = $AnimatedSprite2D
@onready var frog_sound = $Ribbit



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		frog_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_leftp1", "move_rightp1")
	if direction !=0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
			
	move_and_slide()

#animations
	if not is_on_floor():
		sprite.flip_h = direction < 0
		if velocity.y < 0:
			if sprite.animation != "jump":
				sprite.play("jump")
		elif velocity.y > 0:
			if sprite.animation != "fall":
				sprite.play("fall")
	else:
		if direction != 0:
			var walk_animation = "move_right" if direction > 0 else "move_left"
			if sprite.animation != walk_animation:
				sprite.play(walk_animation)
		else:
			if sprite.animation != "idle":
				sprite.play("idle")
