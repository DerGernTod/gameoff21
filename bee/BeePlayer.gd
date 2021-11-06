extends "res://bee/Bee.gd"


func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		move(true)
	if Input.is_action_pressed("move_backward"):
		move(false)
	if Input.is_action_pressed("turn_right"):
		turn(true)
	if Input.is_action_pressed("turn_left"):
		turn(false)
