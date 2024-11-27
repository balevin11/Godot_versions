extends Area2D

@onready var game_manager: Node = %GameManager
@onready var sound_coin: AudioStreamPlayer2D = $sound_coin
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
		game_manager.new_coin()
		sound_coin.play()
		animated_sprite.visible = false
		collision_shape.call_deferred("set", "disabled", true)
		 # Replace with function body.
		


func _on_sound_coin_finished() -> void:
	queue_free() # Replace with function body.
