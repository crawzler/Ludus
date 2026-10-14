extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)
signal defeated

enum Weapon { SWORD, SPEAR }

const MOVE_SPEED: float = 300.0
const ATTACK_DAMAGE: int = 1
const SWORD_ATTACK_RANGE: float = 48.0
const SWORD_ATTACK_INTERVAL: float = 0.35
const SPEAR_ATTACK_RANGE: float = 80.0
const SPEAR_ATTACK_INTERVAL: float = 0.7
const ATTACK_FEEDBACK_DURATION: float = 0.12
const BLOCK_FEEDBACK_DURATION: float = 0.2
const PARRY_FEEDBACK_DURATION: float = 0.45
const DODGE_DURATION: float = 0.2
const DODGE_SPEED_MULTIPLIER: float = 1.5
const DODGE_COOLDOWN: float = 0.6
const MAX_HEALTH: int = 3
const HIT_FLASH_DURATION: float = 0.12
const HIT_COLOR: Color = Color("#fff2a6")
const BLOCK_COLOR: Color = Color("#75d8ff")
const PARRY_COLOR: Color = Color("#ffe66d")
const DODGE_COLOR: Color = Color("#9bfff0")

var equipped_weapon: Weapon = Weapon.SWORD
var attack_cooldown_remaining: float = 0.0
var attack_feedback_range: float = SWORD_ATTACK_RANGE
var attack_feedback_remaining: float = 0.0
var block_feedback_remaining: float = 0.0
var parry_feedback_remaining: float = 0.0
var dodge_time_remaining: float = 0.0
var dodge_cooldown_remaining: float = 0.0
var last_valid_move_direction: Vector2 = Vector2.DOWN
var dodge_direction: Vector2 = Vector2.DOWN
var dodge_active: bool = false
var block_held: bool = false
var health: int = MAX_HEALTH
var combat_finished: bool = false
var hit_flash_tween: Tween


func _physics_process(_delta: float) -> void:
	if combat_finished:
		velocity = Vector2.ZERO
		return

	attack_cooldown_remaining = maxf(attack_cooldown_remaining - _delta, 0.0)
	if Input.is_action_just_pressed("switch_weapon"):
		_switch_weapon()

	var move_direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	dodge_cooldown_remaining = maxf(dodge_cooldown_remaining - _delta, 0.0)
	if not dodge_active and move_direction != Vector2.ZERO:
		last_valid_move_direction = move_direction.normalized()
	if Input.is_action_just_pressed("dodge") and not dodge_active and dodge_cooldown_remaining <= 0.0:
		_start_dodge(move_direction)

	if dodge_active:
		velocity = dodge_direction * MOVE_SPEED * DODGE_SPEED_MULTIPLIER
	else:
		velocity = move_direction * MOVE_SPEED
	move_and_slide()
	if dodge_active:
		dodge_time_remaining = maxf(dodge_time_remaining - _delta, 0.0)
		if dodge_time_remaining <= 0.0:
			dodge_active = false
		queue_redraw()
	if Input.is_action_just_pressed("attack"):
		_attack()


func _start_dodge(move_direction: Vector2) -> void:
	dodge_direction = move_direction.normalized() if move_direction != Vector2.ZERO else last_valid_move_direction
	dodge_time_remaining = DODGE_DURATION
	dodge_cooldown_remaining = DODGE_COOLDOWN
	dodge_active = true
	queue_redraw()


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
	if attack_cooldown_remaining > 0.0:
		return

	attack_cooldown_remaining = _weapon_attack_interval()
	attack_feedback_remaining = ATTACK_FEEDBACK_DURATION
	attack_feedback_range = _weapon_attack_range()
	queue_redraw()

	var closest_target: Node2D
	var closest_distance: float = attack_feedback_range
	for target: Node2D in get_tree().get_nodes_in_group("attackable"):
		var distance: float = global_position.distance_to(target.global_position)
		if distance <= closest_distance:
			closest_target = target
			closest_distance = distance

	if closest_target:
		closest_target.call("take_damage", ATTACK_DAMAGE)


func _switch_weapon() -> void:
	equipped_weapon = Weapon.SPEAR if equipped_weapon == Weapon.SWORD else Weapon.SWORD
	queue_redraw()


func _weapon_attack_range() -> float:
	match equipped_weapon:
		Weapon.SWORD:
			return SWORD_ATTACK_RANGE
		Weapon.SPEAR:
			return SPEAR_ATTACK_RANGE
		_:
			push_error("Unknown weapon equipped.")
			return 0.0


func _weapon_attack_interval() -> float:
	match equipped_weapon:
		Weapon.SWORD:
			return SWORD_ATTACK_INTERVAL
		Weapon.SPEAR:
			return SPEAR_ATTACK_INTERVAL
		_:
			push_error("Unknown weapon equipped.")
			return 0.0


func _weapon_display_name() -> String:
	match equipped_weapon:
		Weapon.SWORD:
			return "ESPADA"
		Weapon.SPEAR:
			return "LANÇA"
		_:
			push_error("Unknown weapon equipped.")
			return "?"


func take_damage(amount: int) -> void:
	if combat_finished or health <= 0 or dodge_active:
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
	dodge_active = false
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
		draw_circle(Vector2.ZERO, attack_feedback_range, Color(1.0, 0.24, 0.12, 0.18))
		draw_arc(
			Vector2.ZERO,
			attack_feedback_range,
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
	if dodge_active:
		var dodge_progress: float = clampf(dodge_time_remaining / DODGE_DURATION, 0.0, 1.0)
		draw_circle(Vector2.ZERO, 25.0, Color(0.25, 0.95, 0.82, 0.2))
		draw_arc(Vector2.ZERO, 27.0, 0.0, TAU, 48, DODGE_COLOR, 3.0, true)
		draw_arc(
			Vector2.ZERO,
			32.0,
			-PI / 2.0,
			-PI / 2.0 + TAU * dodge_progress,
			32,
			DODGE_COLOR,
			4.0,
			true
		)
		draw_line(Vector2.ZERO, dodge_direction * 31.0, DODGE_COLOR, 3.0, true)
		draw_string(
			ThemeDB.fallback_font,
			Vector2(-30.0, -42.0),
			"ROLL",
			HORIZONTAL_ALIGNMENT_CENTER,
			60.0,
			14,
			DODGE_COLOR
		)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(-46.0, -30.0),
		_weapon_display_name(),
		HORIZONTAL_ALIGNMENT_CENTER,
		92.0,
		14,
		Color("#f4f0df")
	)
