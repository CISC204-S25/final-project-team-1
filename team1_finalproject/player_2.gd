extends CharacterBody2D


@export var speed = 350
@export var gravity = 1500
@export var portal_scene: PackedScene
@onready var sprite = $AnimatedSprite2D
@onready var salamander_sound = $walkNoise
var is_shooting = false
var portal_cooldown := false
var portals: Array = []
const portal_cost := 20
const max_portal_y := 745  #minimum y value allowed for portals to spawn


func _physics_process(delta: float) -> void:
	if is_shooting:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = direction > 0
		if is_on_floor() and sprite.animation != "walk":
			sprite.play("walk")
			salamander_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and sprite.animation != "idle":
			sprite.play("idle")
			salamander_sound.stop()
	var camera = get_viewport().get_camera_2d()
	if camera:
		clamp_player2_to_camera(camera)

	move_and_slide()

#function for creating portal
func spawn_portal(target_position: Vector2) -> void:
	if portal_scene:
		var portal = portal_scene.instantiate()
		portal.global_position = target_position
		get_tree().current_scene.add_child(portal)
		sprite.play("shoot")
		is_shooting = true
		
		#make sure you can't make more than two portals
		portals.append(portal)
		if portals.size() > 2:
			var old_portal = portals.pop_front()
			old_portal.queue_free()

		# Link portals when there are two
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

#function to try creating a portal while checking energy
func try_create_portal() -> void:
	var target_position := get_global_mouse_position()
	#prevent creating portal above y threshold
	if target_position.y < max_portal_y:
		var ui = get_tree().current_scene.get_node("/root/Level_1/CanvasLayer/OutOfBoundsWarning")
		ui.show_warning("Can't place portal at this height!")
		return
		
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

func start_portal_cooldown():
	portal_cooldown = true
	await get_tree().create_timer(0.5).timeout
	portal_cooldown = false
	
#prevent player 2 from moving off screen	
func clamp_player2_to_camera(camera: Camera2D):
	var screen_size = get_viewport().get_visible_rect().size
	var half_screen = screen_size * 0.5 * camera.zoom
	var cam_pos = camera.global_position

	var min_bound = cam_pos - half_screen
	var max_bound = cam_pos + half_screen

	global_position.x = clamp(global_position.x, min_bound.x, max_bound.x)
	global_position.y = clamp(global_position.y, min_bound.y, max_bound.y)
