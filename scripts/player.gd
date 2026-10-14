extends CharacterBody2D

const MOVE_SPEED: float = 300.0
const ATTACK_RANGE: float = 48.0
const ATTACK_DAMAGE: int = 1


func _physics_process(_delta: float) -> void:
	var move_direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	velocity = move_direction * MOVE_SPEED
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		_attack()


func _attack() -> void:
	for target: Node2D in get_tree().get_nodes_in_group("training_target"):
		if global_position.distance_to(target.global_position) <= ATTACK_RANGE:
			target.call("take_damage", ATTACK_DAMAGE)
			return


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("#54d5bd"))
	draw_circle(Vector2(0.0, -7.0), 4.0, Color("#f0f4ee"))
