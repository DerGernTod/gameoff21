extends Node2D

var _stats = {
	color = Color.rebeccapurple,
}


func die() -> void:
	queue_free()


func _ready() -> void:
	modulate = _stats.color


func _on_Area2D_body_entered(body: Node) -> void:
	print("body entered")
#	die()


func _on_Area2D_body_exited(body: Node) -> void:
	print("body left")
