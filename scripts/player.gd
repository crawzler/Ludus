extends CharacterBody2D

const MOVE_SPEED: float = 300.0
const ATTACK_RANGE: float = 48.0
const ATTACK_DAMAGE: int = 1
const ATTACK_FEEDBACK_DURATION: float = 0.12

var attack_feedback_remaining: float = 0.0


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


func _process(delta: float) -> void:
	if attack_feedback_remaining <= 0.0:
		return

	attack_feedback_remaining = maxf(attack_feedback_remaining - delta, 0.0)
	if is_zero_approx(attack_feedback_remaining):
		queue_redraw()


func _attack() -> void:
	attack_feedback_remaining = ATTACK_FEEDBACK_DURATION
	queue_redraw()

	var closest_target: Node2D
	var closest_distance: float = ATTACK_RANGE
	for target: Node2D in get_tree().get_nodes_in_group("attackable"):
		var distance: float = global_position.distance_to(target.global_position)
		if distance <= closest_distance:
			closest_target = target
			closest_distance = distance

	if closest_target:
		closest_target.call("take_damage", ATTACK_DAMAGE)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 18.0, Color("#54d5bd"))
	draw_circle(Vector2(0.0, -7.0), 4.0, Color("#f0f4ee"))
	if attack_feedback_remaining > 0.0:
		draw_circle(Vector2.ZERO, ATTACK_RANGE, Color(1.0, 0.24, 0.12, 0.18))
		draw_arc(
			Vector2.ZERO,
			ATTACK_RANGE,
			0.0,
			TAU,
			48,
			Color("#ff684f"),
			2.0,
			true
		)
