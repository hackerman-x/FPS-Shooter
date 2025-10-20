class_name Gun
extends Node3D

var BulletHoleScene = preload("res://Scenes/bullet_hole.tscn")

@export var shooting_range:float = 0.0
@onready var player_camera:Camera3D = $"/root/World/Player/Head/PlayerCamera"

var can_shoot = true
var bullethole :Node3D
var bulletholes = []

func _shoot() -> void:
	if can_shoot:
		can_shoot = false
		var space_state:PhysicsDirectSpaceState3D = player_camera.get_world_3d().direct_space_state
		var ray_start: Vector3 = player_camera.global_position

		var ray_direction:Vector3 = -player_camera.global_basis.z
		var ray_end:Vector3 = ray_start + ray_direction.normalized() * shooting_range

		var query := PhysicsRayQueryParameters3D.create(ray_start, ray_end)
		query.collide_with_bodies = true
		var result:Dictionary = space_state.intersect_ray(query)

		$ShootCooldown.start()
		if not result.is_empty():
			$Bullet_Hole_Timer.start()
			bullethole = BulletHoleScene.instantiate()
			result["collider"].add_child(bullethole)
			bullethole.global_position = result["position"]
			var up_vector = Vector3.UP
			if abs(result["normal"].dot(up_vector)) > 0.999:
				# normal is almost parallel to up, use a different up
				up_vector = Vector3.FORWARD  # or Vector3(0,0,1)
			bullethole.look_at(result["position"] + result["normal"], up_vector)

			# Keep the bullet hole roughly normal size
			var parent_scale = result["collider"].global_transform.basis.get_scale()
			var uniform_scale = (parent_scale.x + parent_scale.y + parent_scale.z) / 1.0
			bullethole.scale = Vector3.ONE / uniform_scale
			bulletholes.append(bullethole)




func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		$Muzzle_particels.emitting = true
		$MuzzleFlash.visible = true
		_shoot()

#@export var BulletScene: PackedScene = preload("res://Scenes/Bullet.tscn")
#@export var camera: Camera3D
#@export var muzzle:Node3D
#
#var previous_x: float = 0.0
#var cam: Camera3D
#var shootable = true
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#muzzle = $Muzzle
	#camera = $"/root/World/Player/Head/Camera3D"
	#if camera:
		#previous_x = camera.global_position.x
#
#func shoot() -> void:
	#if shootable:
		#var bullet = BulletScene.instantiate()
		#var bullet_container = get_tree().current_scene.get_node("Bullets")
		#bullet_container.add_child(bullet)
		#if muzzle:
			#bullet.global_transform.origin = muzzle.global_transform.origin
		#else:
			#bullet.global_transform.origin = camera.global_transform.origin
		#bullet.global_rotation = camera.global_rotation
		#shootable = false
		#$ShootCooldown.start()
		#bullet.translate(Vector3(0, 0, -1)) 
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
#
#
#
func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
	$Muzzle_particels.emitting = false
	$MuzzleFlash.visible = false


func _on_bullet_hole_timer_timeout() -> void:
	print("OH")
