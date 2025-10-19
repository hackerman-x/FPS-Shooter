extends Node3D

@export var BulletScene: PackedScene = preload("res://Scenes/Bullet.tscn")
@export var speed := 50.0
@export var camera: Camera3D
@export var muzzle:Node3D

var previous_x: float = 0.0
var cam: Camera3D
var shootable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	muzzle = $Muzzle
	camera = $"/root/World/Player/Head/Camera3D"
	if camera:
		previous_x = camera.global_position.x

func shoot() -> void:
	if shootable:
		var bullet = BulletScene.instantiate()
		var bullet_container = get_tree().current_scene.get_node("Bullets")
		bullet_container.add_child(bullet)
		if muzzle:
			bullet.global_transform.origin = muzzle.global_transform.origin
		else:
			bullet.global_transform.origin = camera.global_transform.origin
		bullet.global_rotation = camera.global_rotation
		shootable = false
		$ShootCooldown.start()
		bullet.translate(Vector3(0, 0, -1)) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_shoot_cooldown_timeout() -> void:
	shootable = true
