extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)
signal defeated

const MOVE_SPEED: float = 300.0
const ATTACK_RANGE: float = 48.0
const ATTACK_DAMAGE: int = 1
const ATTACK_FEEDBACK_DURATION: float = 0.12
const BLOCK_FEEDBACK_DURATION: float = 0.2
const PARRY_FEEDBACK_DURATION: float = 0.45
const MAX_HEALTH: int = 3
const HIT_FLASH_DURATION: float = 0.12
const HIT_COLOR: Color = Color("#fff2a6")
const BLOCK_COLOR: Color = Color("#75d8ff")
const PARRY_COLOR: Color = Color("#ffe66d")

var attack_feedback_remaining: float = 0.0
var block_feedback_remaining: float = 0.0
var parry_feedback_remaining: float = 0.0
var block_held: bool = false
var health: int = MAX_HEALTH
var combat_finished: bool = false
var hit_flash_tween: Tween


func _physics_process(_delta: float) -> void:
	if combat_finished:
		velocity = Vector2.ZERO
		return

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
	var currently_blocking: bool = not combat_finished and Input.is_action_pressed("block")
	if block_held != currently_blocking:
		block_held = currently_blocking
		queue_redraw()

	if attack_feedback_remaining > 0.0:
		attack_feedback_remaining = maxf(attack_feedback_remaining - delta, 0.0)
		queue_redraw()
	if block_feedback_remaining > 0.0:
		block_feedback_remaining = maxf(block_feedback_remaining - delta, 0.0)
		queue_redraw()
	if parry_feedback_remaining > 0.0:
		parry_feedback_remaining = maxf(parry_feedback_remaining - delta, 0.0)
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


func take_damage(amount: int) -> void:
	if combat_finished or health <= 0:
		return

	health = maxi(health - amount, 0)
	health_changed.emit(health, MAX_HEALTH)
	_show_hit_feedback()
	if health == 0:
		defeated.emit()


func try_block_attack() -> bool:
	if combat_finished or not Input.is_action_pressed("block"):
		return false

	block_feedback_remaining = BLOCK_FEEDBACK_DURATION
	queue_redraw()
	return true


func try_parry_attack() -> bool:
	if combat_finished or not Input.is_action_just_pressed("block"):
		return false

	parry_feedback_remaining = PARRY_FEEDBACK_DURATION
	queue_redraw()
	return true


func finish_combat() -> void:
	combat_finished = true
	block_held = false
	velocity = Vector2.ZERO
	set_physics_process(false)
	queue_redraw()


func get_health_text() -> String:
	return "Jogador: %d/%d" % [health, MAX_HEALTH]


func _show_hit_feedback() -> void:
	if hit_flash_tween and hit_flash_tween.is_running():
		hit_flash_tween.kill()
	modulate = HIT_COLOR
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(self, "modulate", Color.WHITE, HIT_FLASH_DURATION)


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
	if block_held:
		draw_circle(Vector2.ZERO, 26.0, Color(0.16, 0.65, 0.95, 0.2))
		draw_arc(Vector2.ZERO, 26.0, 0.0, TAU, 48, BLOCK_COLOR, 3.0, true)
	if block_feedback_remaining > 0.0:
		draw_arc(Vector2.ZERO, 32.0, 0.0, TAU, 48, BLOCK_COLOR, 4.0, true)
		draw_string(
			ThemeDB.fallback_font,
			Vector2(-48.0, -34.0),
			"BLOQUEIO",
			HORIZONTAL_ALIGNMENT_CENTER,
			96.0,
			14,
			BLOCK_COLOR
		)
	if parry_feedback_remaining > 0.0:
		draw_arc(Vector2.ZERO, 38.0, 0.0, TAU, 48, PARRY_COLOR, 5.0, true)
		draw_string(
			ThemeDB.fallback_font,
			Vector2(-36.0, -42.0),
			"APARO!",
			HORIZONTAL_ALIGNMENT_CENTER,
			72.0,
			16,
			PARRY_COLOR
		)
