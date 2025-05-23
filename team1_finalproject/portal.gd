extends Area2D

var linked_portal: Area2D = null
@onready var portalAnimation = $PortalAnimatedSprite

func _ready():
	portalAnimation.play("spawn_portal")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player2") and not body.portal_cooldown:
		if linked_portal:
			#set player to portal cooldown
			body.start_portal_cooldown()
			body.global_position = linked_portal.global_position + Vector2(0,-10)
