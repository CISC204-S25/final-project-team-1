extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var button_click = $ButtonClick
@export var target_platforms: Array[NodePath] #manually select node in scene tree
var activated := false
var can_activate := false

#short cooldown to prevent button from accidentally having collisions when loading in
func _ready():
	await get_tree().create_timer(0.2).timeout
	can_activate = true

#detects if player entered then turns visible and turns on collision/mask layers
func _on_body_entered(body: Node2D) -> void:
	if not can_activate:
		return
	if body.is_in_group("player"):
		sprite.play("ButtonPressed")
		button_click.play()
	if activated:
		return 
	activated = true #prevent button from reactivating

	for path in target_platforms:
		if has_node(path):
			var platform = get_node(path)
			platform.visible = true
			if platform is StaticBody2D:
				platform.set_deferred("collision_layer", 1) 
				platform.set_deferred("collision_mask", 1 | 2 | 4)
