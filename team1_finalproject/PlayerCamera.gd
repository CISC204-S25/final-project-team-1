extends Camera2D

@export var player_1_jumper: Node2D
@export var player_2_portal: Node2D
@export var min_zoom: Vector2 = Vector2(1, 1)
@export var max_zoom: Vector2 = Vector2(3, 3)
@export var margin: float = 200

func _process(delta):
	if not player_1_jumper or not player_2_portal:
		return

	#always center on Player 1
	global_position = player_1_jumper.global_position

	#find distance between players
	var distance = player_1_jumper.global_position.distance_to(player_2_portal.global_position)
	#determine zoom level based on distance between players
	var zoom_factor = clamp(distance / margin, min_zoom.x, max_zoom.x)
	zoom = Vector2(zoom_factor, zoom_factor)
