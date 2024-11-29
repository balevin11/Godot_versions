extends StaticBody2D

var direction : int
var velocity: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += velocity * delta * direction


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free() # Replace with function body.
