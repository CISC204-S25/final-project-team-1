extends CharacterBody2D


@export var speed = 200
@export var gravity = 1000
@export var portal_scene: PackedScene

var portals: Array = []

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

#function for creating portal
func spawn_portal(position: Vector2) -> void:
	if portal_scene:
		var portal = portal_scene.instantiate()
		portal.global_position = position
		get_tree().current_scene.add_child(portal)
		
		#make sure you can't make more than two portals
		portals.append(portal)
		if portals.size() > 2:
			var old_portal = portals.pop_front()
			old_portal.queue_free()

		# Link portals if there are two
		if portals.size() == 2:
			portals[0].linked_portal = portals[1]
			portals[1].linked_portal = portals[0]

#function for placing portal with mouseclick while making sure it doesn't interfere with UI
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var click_position = get_global_mouse_position()
		spawn_portal(click_position)
