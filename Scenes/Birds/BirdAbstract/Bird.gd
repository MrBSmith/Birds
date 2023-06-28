extends Node2D
class_name Bird

@export_range(0.0, 9999.0) var speed : float = 200.0

var current_spot : BirdSpot

var direction := Vector2.RIGHT:
	set(value):
		if value != direction:
			direction = value
			direction_changed.emit(direction)

signal started_moving
signal stopped_moving
signal direction_changed(dir: Vector2)


func move_to_spot(spot: BirdSpot) -> void:
	spot.bird = self
	
	await fly(spot.global_position)
	started_moving.connect(spot.set.bind("bird", null), CONNECT_ONE_SHOT)


func _move_to(to: Vector2) -> void:
	started_moving.emit()
	
	var tween = create_tween()
	var duration = global_position.distance_to(to) / speed if speed != 0.0 else 0.0
	
	direction = global_position.direction_to(to)
	tween.tween_property(self, "position", to, duration)
	
	await tween.finished
	stopped_moving.emit()
	
	$StateMachine.set_state("Idle")


func fly(to: Vector2) -> void:
	$StateMachine.set_state("Fly")
	await _move_to(to)


func seek_spot() -> BirdSpot:
	var spots_array = get_tree().get_nodes_in_group("BirdSpot") as Array[BirdSpot]
	spots_array.shuffle()
	
	for spot in spots_array:
		if spot.is_free():
			return spot
	
	return null

