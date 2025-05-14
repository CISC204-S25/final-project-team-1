extends CharacterBody2D


@export var speed = 400
@export var gravity = 1500
@export var portal_scene: PackedScene
@onready var walking = $Walk
@onready var portal_sound = $Portal
	

var portal_cooldown := false
var portals: Array = []

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction := Input.get_axis("move_left", "move_right")
	walking.play()
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

#function for creating portal
func spawn_portal(target_position: Vector2) -> void:
	portal_sound.play()
	if portal_scene:
		var portal = portal_scene.instantiate()
		portal.global_position = target_position
		get_tree().current_scene.add_child(portal)
		
		#make sure you can't make more than two portals
		portals.append(portal)
		if portals.size() > 2:
			var old_portal = portals.pop_front()
			old_portal.queue_free()

		# Link portals when there are two
		if portals.size() == 2:
			portals[0].linked_portal = portals[1]
			portals[1].linked_portal = portals[0]

#function for placing portal with mouseclick while making sure it doesn't interfere with UI
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		spawn_portal(get_global_mouse_position())
		
func _on_portal_entered(portal_area: Area2D) -> void:
	spawn_portal(portal_area.global_position)

func start_portal_cooldown():
	portal_cooldown = true
	await get_tree().create_timer(0.5).timeout
	portal_cooldown = false
