@tool
extends State

@onready var wait_timer: Timer = $WaitTimer

@export_range(0.0, 99.0) var avg_wait_time : float
@export_range(0.0, 99.0) var wait_time_variance : float 

func enter_state() -> void:
	wait_timer.start(randfn(avg_wait_time, wait_time_variance))


func _on_wait_timer_timeout() -> void:
	if is_current_state():
		owner.move_to_random_spot()
