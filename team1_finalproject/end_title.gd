extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_to_title_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_quit_button_pressed() -> void:
	pass 
	get_tree().quit()
