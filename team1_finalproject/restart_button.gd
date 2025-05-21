extends Button



func _on_pressed() -> void:
	get_tree().reload_current_scene()
	PortalEnergy.current_energy = 0
