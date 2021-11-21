extends Node2D

var _stats: Dictionary


func die() -> void:
	queue_free()


func load_stats(stats: FlowerStats) -> void:
	_stats = stats._stats
	scale = Vector2.ONE * _stats.size
	modulate = _stats.color


func _ready() -> void:
	pass


func _on_Area2D_body_entered(body: Node) -> void:
#	print("body entered")
#	die()
	pass


func _on_Area2D_body_exited(body: Node) -> void:
#	print("body left")
	pass
