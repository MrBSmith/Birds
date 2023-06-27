@tool
extends StateMachine

var current_spot : BirdSpot = null

@export var wait_timer : Timer

@export_range(0.0, 99.0) var avg_wait_time : float
@export_range(0.0, 99.0) var wait_time_variance : float


func _ready() -> void:
	if wait_timer:
		wait_timer.timeout.connect(_on_wait_timer_timeout)


func enter_state() -> void:
	if wait_timer:
		wait_timer.start(randfn(avg_wait_time, wait_time_variance))


func _on_wait_timer_timeout() -> void:
	if is_current_state():
		var spot = owner.seek_spot()
		
		if spot:
			owner.move_to_spot(spot)
