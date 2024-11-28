extends CharacterBody2D


const SPEED = 60

@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castright: RayCast2D = $RayCastright
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dead_zone: Area2D = $dead_zone
@onready var timer: Timer = $Timer

var is_alive = true
var player_alive = true

func _ready() -> void:
	velocity.x = -SPEED
	
func _on_timer_timeout() -> void:
	queue_free()# Replace with function body.

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("fall")
		
	if ray_castleft.is_colliding():
		velocity.x = SPEED
		animated_sprite.flip_h = true
	if ray_castright.is_colliding():
		velocity.x = -SPEED
		animated_sprite.flip_h = false
	$AnimatedSprite2D.play("run")
	
	move_and_slide()
