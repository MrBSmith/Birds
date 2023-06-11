@tool
extends Node2D
class_name Bird

@onready var body: AnimatedSprite2D = %Body

@export var speed : float = 200.0
@export var color : Color:
	set(value):
		if value != color:
			color = value
			color_changed.emit(color)

var direction := Vector2.RIGHT:
	set(value):
		if value != direction:
			direction = value
			direction_changed.emit(direction)

signal direction_changed(dir: Vector2)
signal color_changed(color)
signal started_moving
signal stopped_moving


func move_to_random_spot() -> void:
	var spots_array = get_tree().get_nodes_in_group("BirdSpot")
	spots_array.shuffle()
	
	for spot in spots_array:
		if spot.position.is_equal_approx(position):
			continue
		
		move_to_point(spot.position)
		return


func move_to_point(point: Vector2) -> void:
	started_moving.emit()
	
	var tween = create_tween()
	var duration = position.distance_to(point) / speed
	
	direction = position.direction_to(point)
	tween.tween_property(self, "position", point, duration)
	
	await tween.finished
	stopped_moving.emit()

