extends CharacterBody2D


@export var speed = 350
@export var gravity = 1500
@export var portal_scene: PackedScene
@export var max_player_distance := 950 #max distance from other player
@export var other_player: Node2D
@export var max_portal_y := 950  #minimum y value allowed for portals to spawn
@onready var walk_sound = $walkNoise
@onready var portal_sound = $PortalSound
@onready var sprite = $AnimatedSprite2D
@onready var respawn_position: Vector2 = global_position


var is_shooting = false
var portal_cooldown := false
var portals: Array = []
const portal_cost := 20

	
func _physics_process(delta: float) -> void:
	if is_shooting:
		return #so player can't shoot and move at the same time
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = direction > 0
		if is_on_floor() and sprite.animation != "walk":
			sprite.play("walk")
			if not walk_sound.playing:
				walk_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and sprite.animation != "idle":
			sprite.play("idle")
			if walk_sound.playing:
				walk_sound.stop()
				
#check if distance from other player exceeds maximum distance then stops movement if it does
	var next_position = global_position + Vector2(direction * speed * delta, 0)
	var distance = next_position.distance_to(other_player.global_position)

	if distance <= max_player_distance:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		
	if is_on_floor():
		respawn_position = global_position #update last position for respawning
		check_platform_collision()
		
	move_and_slide()
	if is_on_floor():
		var collision = get_slide_collision(0) #player inherits velocity of moving platform to stay on it
		if collision:
			var collider = collision.get_collider()
			if collider is CharacterBody2D and collider.name == "MovingPlatform":
				velocity.x += collider.velocity.x
	
#prevent errors with moving platform by checking collisions
func check_platform_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			if collider is CharacterBody2D and collider.name == "MovingPlatform":
				velocity.x += collider.velocity.x
	
#function for creating portal
func spawn_portal(target_position: Vector2) -> void:
	portal_sound.play()
	if portal_scene:
		var portal = portal_scene.instantiate()
		portal.global_position = target_position
		get_tree().current_scene.add_child(portal)
		sprite.play("shoot")
		is_shooting = true
		
		#make sure you can't make more than two portals using array
		portals.append(portal)
		if portals.size() > 2:
			var old_portal = portals.pop_front()
			old_portal.queue_free()

		#link portals when there are two
		if portals.size() == 2:
			portals[0].linked_portal = portals[1]
			portals[1].linked_portal = portals[0]
			
	await sprite.animation_finished
	is_shooting = false
	if is_on_floor():
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			sprite.play("walk")
		else:
			sprite.play("idle")

#avoid placing portals over static body 2Ds and the player themself
@warning_ignore("shadowed_variable_base_class")
func portal_placement_check(position: Vector2, size: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var shape = CapsuleShape2D.new() #make sure the portal can fit in an area based on its collision shape
	shape.radius = size.x / 2
	shape.height = size.y - size.x
	var transform = Transform2D()
	transform.origin = position

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, position)
	query.collision_mask = 1
	query.exclude = [self]

	var result = space_state.intersect_shape(query, 1)
	return result.is_empty()

#function to try creating a portal while checking energy and position
func try_create_portal() -> void:
	var target_position := get_global_mouse_position()
	#prevent creating portal above y threshold
	if target_position.y < max_portal_y:
		var ui = get_tree().current_scene.get_node("CanvasLayer/OutOfBoundsWarning")
		ui.show_warning("Can't place portal at this height!")
		return
		
	var portal = portal_scene.instantiate()
	var shape_node = portal.get_node("CollisionShape2D")
	var shape = shape_node.shape as CapsuleShape2D
	var portal_size = Vector2(52, 160)
	if shape:
		var width = shape.radius * 2
		var height = shape.height + shape.radius * 2
		portal_size = Vector2(width, height)
	if not portal_placement_check(target_position, portal_size):
		var ui = get_tree().current_scene.get_node("CanvasLayer/OutOfBoundsWarning")
		ui.show_warning("Can't place portal here!")
		return
		
		#spawn portal if enough energy
	if PortalEnergy.consume_energy(portal_cost):
		spawn_portal(get_global_mouse_position())
	else:
		var ui = get_tree().current_scene.get_node("CanvasLayer/EnergyUI")
		if ui.has_method("show_low_energy_warning"):
			ui.show_low_energy_warning()
		
#function for placing portal with mouseclick while making sure it doesn't interfere with UI
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		try_create_portal()
		
func _on_portal_entered(portal_area: Area2D) -> void:
	spawn_portal(portal_area.global_position)

#avoid teleporting again immediately after going through portal
func start_portal_cooldown():
	portal_cooldown = true
	await get_tree().create_timer(0.5).timeout
	portal_cooldown = false
	
