extends Area2D

signal portal_entered(portal: Node)
var linked_portal: Area2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not body.portal_cooldown:
		if linked_portal:
			# Set player to portal cooldown
			body.start_portal_cooldown()
			body.global_position = linked_portal.global_position + Vector2(0,-10)
