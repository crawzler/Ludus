extends CharacterBody2D

const MOVE_SPEED: float = 300.0


func _physics_process(_delta: float) -> void:
	var move_direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	velocity = move_direction * MOVE_SPEED
	move_and_slide()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("#54d5bd"))
	draw_circle(Vector2(0.0, -7.0), 4.0, Color("#f0f4ee"))
