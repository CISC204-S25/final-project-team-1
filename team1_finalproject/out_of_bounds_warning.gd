extends Label


@export var OOBwarning_label = Node2D

func show_warning(message: String, duration := 1.5):
	OOBwarning_label.text = message
	OOBwarning_label.visible = true
	await get_tree().create_timer(duration).timeout
	OOBwarning_label.visible = false
