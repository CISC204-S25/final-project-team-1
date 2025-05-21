extends Control




func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
	


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
