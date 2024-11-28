extends CharacterBody2D

const SPEED = 60
const CHARGE_SPEED = 200

@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castright: RayCast2D = $RayCastright
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_zone: Area2D = $dead_zone
@onready var timer: Timer = $Timer
@onready var bounce_zone: Area2D = $bounce_zone
@onready var sound_dead: AudioStreamPlayer2D = $sound_dead
@onready var ray_cast_attack: RayCast2D = $RayCastAttack
@onready var stun: Timer = $stun

var is_alive = true
var player_alive = true
var charge = false
var has_collided = 0

func _ready() -> void:
	velocity.x = -SPEED 

func _physics_process(delta: float) -> void:
	if is_alive:
		if not is_on_floor():
			velocity += get_gravity() * delta
			$AnimatedSprite2D.play("fall")
			
		if !charge:
			if ray_castleft.is_colliding():
				velocity.x = SPEED
				animated_sprite.flip_h = true
				ray_cast_attack.rotation_degrees = -90
			if ray_castright.is_colliding():
				velocity.x = -SPEED
				animated_sprite.flip_h = false
				ray_cast_attack.rotation_degrees = 90
			$AnimatedSprite2D.play("walk")
		
			if ray_cast_attack.is_colliding():
				charge = true
		
		if charge:
			if ray_castleft.is_colliding() || ray_castright.is_colliding():
				has_collided += 1
			elif animated_sprite.flip_h == false:
				velocity.x = -CHARGE_SPEED
				$AnimatedSprite2D.play("charge")
			elif animated_sprite.flip_h == true:
				velocity.x = CHARGE_SPEED
				$AnimatedSprite2D.play("charge")
			if has_collided == 1:
				velocity.x = 0
				$AnimatedSprite2D.play("stun")
				stun.start()
			
			

		move_and_slide()
		
func _on_timer_timeout() -> void:
	queue_free()# Replace with function body.


func _on_bounce_zone_body_entered(body: Node2D) -> void:
	if player_alive:
		velocity.x = 0
		dead_zone.queue_free()
		bounce_zone.queue_free()
		is_alive = false
		$AnimatedSprite2D.play("hit") 
		sound_dead.play()
		timer.start()


func _on_dead_zone_body_entered(body: Node2D) -> void:
	player_alive = false# Replace with function body.

func _on_stun_timeout() -> void:
	has_collided = 0
	charge = false 
	if animated_sprite.flip_h == false:
		velocity.x = SPEED
		ray_cast_attack.rotation_degrees = 90
	else:
		velocity.x = SPEED
		ray_cast_attack.rotation_degrees = -90
	$AnimatedSprite2D.play("walk")
