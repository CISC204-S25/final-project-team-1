extends Area2D

#detects if body is player then respawns player
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.global_position = body.respawn_position
