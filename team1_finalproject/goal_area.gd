extends Area2D


signal level_complete

#check to make sure both players have reached goal
@export var total_players := 2
var players_inside := []

#checks if body entered is a player then appends player to array (if not already done so)
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body not in players_inside:
		players_inside.append(body)
		check_completion()
#check if players inside goal area is equal to total players
func check_completion():
	if players_inside.size() == total_players:
		level_complete.emit()
#detects if player leaves area then removes them from array
func _on_body_exited(body: Node2D) -> void:
	if body in players_inside:
		players_inside.erase(body)
