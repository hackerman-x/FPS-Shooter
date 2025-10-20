extends Node3D

@export var speed := 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0, 0, -speed * delta))
