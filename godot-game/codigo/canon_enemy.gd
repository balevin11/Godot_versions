extends CharacterBody2D



const SPEED = 60
const SHOT_SPEED = 200

@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castright: RayCast2D = $RayCastright
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_zone: Area2D = $dead_zone
@onready var timer: Timer = $Timer
@onready var bounce_zone: Area2D = $bounce_zone
@onready var sound_dead: AudioStreamPlayer2D = $sound_dead
@onready var ray_cast_attack: RayCast2D = $RayCastAttack
@onready var attack: Timer = $attack

const bullet_scene  = preload("res://escenas/canon_ball.tscn")

var is_alive = true
var shot = 0


func _ready() -> void:
	velocity.x = -SPEED 

func _physics_process(delta: float) -> void:
	if is_alive:
		if not is_on_floor():
			velocity += get_gravity() * delta
			
			
		if shot == 0:
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
				shot += 1
				
		if shot == 1:
			velocity.x = 0
			$AnimatedSprite2D.play("attack")
			attack.start()
			var bullet = bullet_scene.instantiate()
			bullet.position = global_position
			if animated_sprite.flip_h == false:
				bullet.direction = -1
			else:
				bullet.direction = 1
			get_tree().current_scene.add_child(bullet)
	
			
	move_and_slide()
		
		
func _on_timer_timeout() -> void:
	queue_free()# Replace with function body.


func _on_bounce_zone_body_entered(body: Node2D) -> void:
	velocity.x = 0
	dead_zone.queue_free()
	bounce_zone.queue_free()
	is_alive = false
	$AnimatedSprite2D.play("hit") 
	sound_dead.play()
	timer.start()



func _on_attack_timeout() -> void:
	if is_alive:
		shot = 0
		if animated_sprite.flip_h == false:
			velocity.x = SPEED
			ray_cast_attack.rotation_degrees = 90
		else:
			velocity.x = SPEED
			ray_cast_attack.rotation_degrees = -90
		$AnimatedSprite2D.play("walk")
