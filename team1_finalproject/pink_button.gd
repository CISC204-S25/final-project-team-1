extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var button_click = $ButtonClick
@export var target_platforms: Array[NodePath]
var activated := false
var can_activate := false

func _ready():
	await get_tree().create_timer(0.2).timeout
	can_activate = true

func _on_body_entered(body: Node2D) -> void:
	if not can_activate:
		return
	if body.is_in_group("player"):
		sprite.play("ButtonPressed")
		button_click.play()
	if activated:
		return 
	activated = true

	for path in target_platforms:
		if has_node(path):
			var pillar = get_node(path)
			pillar.visible = true
			if pillar is StaticBody2D:
				pillar.set_deferred("collision_layer", 1) 
				pillar.set_deferred("collision_mask", 1 | 2 | 4)
