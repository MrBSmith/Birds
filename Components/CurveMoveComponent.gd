extends MoveComponent
class_name CurveMoveComponent

@export_category("Curve")

@export_range(0.0, 1.0) var handle_angle_ratio : float = 0.3
@export_range(0.0, 1.0) var handle_angle_variation : float = 0.3

@export_range(0.0, 1.0) var handle_length_ratio : float = 0.5
@export_range(0.0, 1.0) var handle_length_variation : float = 0.5

var curve : Curve2D

func move(to: Vector2) -> void:
	started_moving.emit()
	
	var from = holder.global_position
	var duration = from.distance_to(to) / speed if speed != 0.0 else 0.0
	
	direction = from.direction_to(to)
	
	curve = Curve2D.new()
	
	var from_handle_vec = _compute_handle_vector(from, to)
	var to_handle_vec = _compute_handle_vector(to, from)
	
	curve.add_point(from, Vector2.ZERO, from_handle_vec)
	curve.add_point(to, to_handle_vec)
	
	var curve_len = curve.get_baked_length()
	
	var tween = create_tween()
	
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_method(_move_along_curve, 0.0, curve_len, duration)
	
	await tween.finished
	
	stopped_moving.emit()


func _move_along_curve(dist_along_curve: float) -> void:
	var pos = curve.sample_baked(dist_along_curve)
	holder.set_global_position(pos)


func _compute_handle_vector(from: Vector2, to: Vector2) -> Vector2:
	var rot = randfn(PI * handle_angle_ratio, PI * handle_angle_variation)
	var length = from.distance_to(to) * randfn(handle_length_ratio, handle_length_variation)
	
	return from.direction_to(to).rotated(rot) * length
