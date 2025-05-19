extends Label


@onready var OOBwarning_label = get_node("/root/Level_1/CanvasLayer/OutOfBoundsWarning")

func show_warning(message: String, duration := 1.5):
	OOBwarning_label.text = message
	OOBwarning_label.visible = true
	await get_tree().create_timer(duration).timeout
	OOBwarning_label.visible = false
