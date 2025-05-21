extends Area2D


signal level_complete

@export var total_players := 2
var players_inside := []


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body not in players_inside:
		players_inside.append(body)
		check_completion()

func check_completion():
	if players_inside.size() == total_players:
		level_complete.emit()

func _on_body_exited(body: Node2D) -> void:
	if body in players_inside:
		players_inside.erase(body)
