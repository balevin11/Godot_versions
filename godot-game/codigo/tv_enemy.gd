extends CharacterBody2D

const SPEED = 60
var direction = -1
@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castright: RayCast2D = $RayCastright
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_zone: Area2D = $dead_zone
@onready var timer: Timer = $Timer
@onready var bounce_zone: Area2D = $bounce_zone
@onready var sound_dead: AudioStreamPlayer2D = $sound_dead

var is_alive = true
var player_alive = true

func _ready() -> void:
	velocity.x = -SPEED 

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("fall")
		
	if is_alive:
		if ray_castleft.is_colliding():
			velocity.x = SPEED
			animated_sprite.flip_h = true
		if ray_castright.is_colliding():
			velocity.x = -SPEED
			animated_sprite.flip_h = false
		$AnimatedSprite2D.play("run")



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
