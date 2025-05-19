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

			
	move_and_slide()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	position = Vector2(-1125, 618)
