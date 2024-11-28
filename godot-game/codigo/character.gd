extends CharacterBody2D

@onready var sound_jump: AudioStreamPlayer2D = $sound_jump

const SPEED = 200.0
const RUN_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -300
const MAX_JUMPS = 2
var jumps = 0
var flooor = true
var run = false
signal effect_run

func start_run() -> void:
	effect_run.emit()

func activate_material(material : Material) -> void:
	$AnimatedSprite2D.material = material

func _ready() -> void:
	$AnimatedSprite2D.play("appear")

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("ui_right"):
		if run:
			velocity.x = RUN_SPEED
		else:
			velocity.x =  SPEED
		if floor:
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("ui_left"):
		if run:
			velocity.x = -RUN_SPEED
		else:
			velocity.x = -SPEED
		if floor:
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true
		

	elif velocity.x == 0 && floor:
		$AnimatedSprite2D.play("idle")
		
	else:
		velocity.x = 0
		
	if is_on_floor():
		flooor = true
		jumps = 0
		
	if Input.is_action_just_pressed("ui_up") and jumps < MAX_JUMPS:
		flooor = false
		if jumps == 0:
			$AnimatedSprite2D.play("jump")
			velocity.y += JUMP_VELOCITY
			sound_jump.play()
			jumps += 1
		elif jumps == 1:
			$AnimatedSprite2D.play("double_jump",1, true)
			velocity.y = DOUBLE_JUMP_VELOCITY
			sound_jump.play()
			jumps += 1
		
	if velocity.y > 0 && !floor && jumps <= 1:
		$AnimatedSprite2D.play("fall")
		
	move_and_slide()
