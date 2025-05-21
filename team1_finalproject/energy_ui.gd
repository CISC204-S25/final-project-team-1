extends Control


@onready var energy_bar = $ProgressBar 
@onready var energy_label = $Label
@onready var warning_label = $EnergyWarningLabel

#uses global portal script to determine energy remaining then displays it
func _process(delta: float) -> void:
	var energy_percent = PortalEnergy.get_energy_percent()
	energy_bar.value = energy_percent * 100
	energy_label.text = "Energy: " + str(PortalEnergy.current_energy) + " / " + str(PortalEnergy.max_energy)

#called when player 2 tries to create a portal but has low energy
func show_low_energy_warning() -> void:
	warning_label.visible = true
	await get_tree().create_timer(2.0).timeout
	warning_label.visible = false
