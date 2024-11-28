extends CharacterBody2D

@onready var sound_jump: AudioStreamPlayer2D = $sound_jump
@onready var dead_icons: Node2D = %dead_icons

const SPEED = 200.0
const RUN_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -300
const MAX_JUMPS = 2
var jumps = 0
var flooor : bool
var run = false
signal effect_run

func start_run() -> void:
	effect_run.emit()

func activate_material(material : Material) -> void:
	$AnimatedSprite2D.material = material

func _ready() -> void:
	$AnimatedSprite2D.play("appear")

func dead() -> void:
	dead_icons.new_dead(position.x,position.y)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps = 0
		flooor = true
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("ui_right"):
		if run:
			velocity.x = RUN_SPEED
		else:
			velocity.x =  SPEED
		if flooor:
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("ui_left"):
		if run:
			velocity.x = -RUN_SPEED
		else:
			velocity.x = -SPEED
		if flooor:
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true
		
	elif velocity.x == 0 && velocity.y == 0 && flooor:
			$AnimatedSprite2D.play("idle")
	else:
		velocity.x = 0
		
	
		
	if Input.is_action_just_pressed("ui_up") and jumps < MAX_JUMPS:
		if jumps == 0:
			$AnimatedSprite2D.play("jump")
			velocity.y += JUMP_VELOCITY
			sound_jump.play()
			jumps += 1
		elif jumps == 1:
			$AnimatedSprite2D.play("double_jump")
			velocity.y = DOUBLE_JUMP_VELOCITY
			sound_jump.play()
			jumps += 1
		flooor = false
		
	if velocity.y > 0 && !flooor && jumps <= 1:
		$AnimatedSprite2D.play("fall")
		
	move_and_slide()
