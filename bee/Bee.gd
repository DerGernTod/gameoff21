extends KinematicBody2D

export(float) var angular_damping = 5
export(float) var velocity_damping = 5

var _stats = {
	max_velocity = 100,
	max_angular_velocity = 10,
}
var _velocity: Vector2 = Vector2.ZERO
var _angular_velocity: float = 0
var _turn_direction: int = 0
var _move_direction: int = 0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var target_velocity = _velocity + transform.basis_xform(Vector2.RIGHT * _stats.max_velocity * _move_direction * delta * velocity_damping * velocity_damping)
	_velocity = target_velocity.clamped(_stats.max_velocity * velocity_damping * velocity_damping)
	_velocity = lerp(_velocity, Vector2.ZERO, delta * velocity_damping)
	_velocity = move_and_slide(_velocity)
	_angular_velocity = clamp(_angular_velocity + _turn_direction * delta * angular_damping * angular_damping,
		-_stats.max_angular_velocity,
		_stats.max_angular_velocity)
	_angular_velocity = lerp(_angular_velocity, 0, delta * angular_damping)
	rotate(_angular_velocity * delta)
	
	_turn_direction = 0
	_move_direction = 0


func turn(right: bool) -> void:
	_turn_direction = 1 if right else -1


func move(forward: bool) -> void:
	_move_direction = 1 if forward else -1

