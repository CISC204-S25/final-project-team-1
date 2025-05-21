extends Control


@export var next_scene:String


func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_next_scene_button_pressed() -> void:
	get_tree().change_scene_to_file(next_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_goal_area_level_complete() -> void:
	show()
