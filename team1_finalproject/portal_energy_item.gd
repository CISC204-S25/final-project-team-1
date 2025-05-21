extends Area2D

@export var energy_value := 20


func _on_body_entered(body):
	if body.is_in_group("Energy_Collector"):
		PortalEnergy.add_energy(energy_value)
		queue_free()
