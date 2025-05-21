extends Camera2D

@export var player1: Node2D
@export var player2: Node2D
@export var follow_speed = 5.0

#checks for players 1 and 2 (assign nodes in inspector), then finds midway point between players
func _process(delta):
	if not player1 or not player2:
		return
	var midpoint = (player1.global_position + player2.global_position) / 2
	position = position.lerp(midpoint, follow_speed * delta)
