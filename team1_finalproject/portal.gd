extends Area2D


var linked_portal: Area2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if linked_portal and body is CharacterBody2D:
		var offset = body.global_position - global_position
		body.global_position = linked_portal.global_position + offset
