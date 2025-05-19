extends Node

var max_energy := 100
var current_energy := 0

func add_energy(amount: int):
	current_energy = clamp(current_energy + amount, 0, max_energy)

func consume_energy(amount: int) -> bool:
	if current_energy >= amount:
		current_energy -= amount
		return true
	return false

func get_energy_percent() -> float:
	return float(current_energy) / max_energy
