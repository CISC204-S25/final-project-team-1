extends CharacterBody2D

@export var point_a: Vector2
@export var point_b: Vector2
@export var speed: float = 60.0

var target: Vector2

func _ready():
	global_position = point_a
	target = point_b

func _physics_process(delta):
	velocity = Vector2.ZERO
	var direction = (target - global_position).normalized()
	var move_amount = direction * speed * delta
	global_position += move_amount

	if global_position.distance_to(target) < 1.0:
		target = point_a if target == point_b else point_b
