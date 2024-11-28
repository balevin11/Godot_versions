extends Area2D


@onready var recolected_sound: AudioStreamPlayer2D = $recolected_sound
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D



func _on_body_entered(body: Node2D) -> void:
	print ("gema de velocidad recogida") # Replace with function body.
	recolected_sound.play()
	animated_sprite.visible = false
	collision_shape.call_deferred("set","disabled",true)
	body.start_run()

func _on_recolected_sound_finished() -> void:
	queue_free() # Replace with function body.
