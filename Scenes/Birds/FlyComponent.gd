extends Node
class_name MoveComponent

@export var holder : Node2D
@export_range(0.0, 9999.0) var speed : float = 200.0
@export var ease_type := Tween.EaseType.EASE_IN_OUT
@export var trans_type := Tween.TransitionType.TRANS_SINE

var direction := Vector2.RIGHT:
	set(value):
		if value != direction:
			direction = value
			direction_changed.emit(direction)

signal started_moving
signal stopped_moving
signal direction_changed(dir: Vector2)


func move_to_spot(spot: BirdSpot) -> void:
	spot.bird = holder
	
	await move(spot.global_position)
	
	started_moving.connect(spot.set.bind("bird", null), CONNECT_ONE_SHOT)


func move(point: Vector2) -> void:
	started_moving.emit()
	
	var tween = create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	
	var duration = holder.position.distance_to(point) / speed if speed != 0.0 else 0.0
	
	direction = holder.position.direction_to(point)
	tween.tween_property(holder, "position", point, duration)
	
	await tween.finished
	stopped_moving.emit()

