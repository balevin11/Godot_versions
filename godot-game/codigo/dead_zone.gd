extends Area2D

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var sound_dead: AudioStreamPlayer2D = $sound_dead



func _on_body_entered(body: Node2D) -> void:
	print("has perdido")
	Engine.time_scale = 0.5
	body.dead()
	body.set_physics_process(false)
	body.get_node("AnimatedSprite2D").play("hit")
	sound_dead.play()
	timer_2.start()
	timer.start()

	
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene() 
	
func _on_timer_2_timeout(body:Node2D) -> void:
	body.get_node("AnimatedSprite2D").play("dessappear")# Replace with function body.
