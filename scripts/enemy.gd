extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)
signal defeated

enum State { CHASING, TELEGRAPHING, ATTACKING, RECOVERING, DEFEATED, FINISHED }

const MOVE_SPEED: float = 90.0
const ATTACK_RANGE: float = 72.0
const ATTACK_DAMAGE: int = 1
const TELEGRAPH_DURATION: float = 0.65
const PARRY_WINDOW_DURATION: float = 0.3
const ATTACK_DURATION: float = 0.18
const RECOVERY_DURATION: float = 1.0
const MAX_HEALTH: int = 3
const HIT_FLASH_DURATION: float = 0.12

const ENEMY_COLOR: Color = Color("#bd514d")
const HIT_COLOR: Color = Color("#fff2a6")
const TELEGRAPH_COLOR: Color = Color(1.0, 0.24, 0.12, 0.12)
const ATTACK_COLOR: Color = Color(1.0, 0.12, 0.06, 0.28)
const PARRY_WINDOW_COLOR: Color = Color("#ffe66d")

var state: State = State.CHASING
var state_time_remaining: float = 0.0
var health: int = MAX_HEALTH
var hit_flash_tween: Tween
var player: CharacterBody2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		push_error("Enemy requires a CharacterBody2D in the 'player' group.")
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	if state == State.DEFEATED or state == State.FINISHED:
		return
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		return

	match state:
		State.CHASING:
			_chase_or_telegraph()
		State.TELEGRAPHING:
			_advance_telegraph(delta)
		State.ATTACKING:
			_advance_attack_state(delta, State.RECOVERING, RECOVERY_DURATION)
		State.RECOVERING:
			_advance_attack_state(delta, State.CHASING, 0.0)
		_:
			return

	move_and_slide()


func _chase_or_telegraph() -> void:
	var to_player: Vector2 = player.global_position - global_position
	if to_player.length() <= ATTACK_RANGE:
		velocity = Vector2.ZERO
		state = State.TELEGRAPHING
		state_time_remaining = TELEGRAPH_DURATION
		queue_redraw()
		return

	velocity = to_player.normalized() * MOVE_SPEED


func _advance_attack_state(delta: float, next_state: State, next_duration: float) -> void:
	velocity = Vector2.ZERO
	state_time_remaining -= delta
	if state_time_remaining <= 0.0:
		state = next_state
		state_time_remaining = next_duration
		queue_redraw()
		if next_state == State.ATTACKING:
			_try_hit_player()


func _advance_telegraph(delta: float) -> void:
	velocity = Vector2.ZERO
	state_time_remaining = maxf(state_time_remaining - delta, 0.0)
	queue_redraw()

	if (
		state_time_remaining > 0.0
		and state_time_remaining <= PARRY_WINDOW_DURATION
		and bool(player.call("try_parry_attack"))
	):
		_enter_recovery()
		return

	if state_time_remaining <= 0.0:
		state = State.ATTACKING
		state_time_remaining = ATTACK_DURATION
		queue_redraw()
		_try_hit_player()


func _enter_recovery() -> void:
	state = State.RECOVERING
	state_time_remaining = RECOVERY_DURATION
	velocity = Vector2.ZERO
	queue_redraw()


func _try_hit_player() -> void:
	if not is_instance_valid(player):
		return
	if global_position.distance_to(player.global_position) <= ATTACK_RANGE:
		if bool(player.call("try_block_attack")):
			return
		player.call("take_damage", ATTACK_DAMAGE)


func take_damage(amount: int) -> void:
	if state == State.DEFEATED or state == State.FINISHED:
		return

	health = maxi(health - amount, 0)
	health_changed.emit(health, MAX_HEALTH)
	_show_hit_feedback()
	if health == 0:
		state = State.DEFEATED
		velocity = Vector2.ZERO
		defeated.emit()
		await get_tree().create_timer(HIT_FLASH_DURATION).timeout
		queue_free()


func finish_combat() -> void:
	state = State.FINISHED
	velocity = Vector2.ZERO
	set_physics_process(false)
	queue_redraw()


func get_health_text() -> String:
	return "Inimigo: %d/%d" % [health, MAX_HEALTH]


func _show_hit_feedback() -> void:
	if hit_flash_tween and hit_flash_tween.is_running():
		hit_flash_tween.kill()
	modulate = HIT_COLOR
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(self, "modulate", Color.WHITE, HIT_FLASH_DURATION)


func _draw() -> void:
	if state == State.TELEGRAPHING:
		if state_time_remaining <= PARRY_WINDOW_DURATION:
			draw_circle(Vector2.ZERO, ATTACK_RANGE, Color(1.0, 0.82, 0.1, 0.24))
			draw_arc(
				Vector2.ZERO,
				ATTACK_RANGE,
				0.0,
				TAU,
				48,
				PARRY_WINDOW_COLOR,
				5.0,
				true
			)
			var window_progress: float = clampf(
				state_time_remaining / PARRY_WINDOW_DURATION,
				0.0,
				1.0
			)
			draw_arc(
				Vector2.ZERO,
				29.0,
				-PI / 2.0,
				-PI / 2.0 + TAU * window_progress,
				32,
				PARRY_WINDOW_COLOR,
				5.0,
				true
			)
			draw_string(
				ThemeDB.fallback_font,
				Vector2(-58.0, -42.0),
				"APARE!",
				HORIZONTAL_ALIGNMENT_CENTER,
				116.0,
				16,
				PARRY_WINDOW_COLOR
			)
		else:
			draw_circle(Vector2.ZERO, ATTACK_RANGE, TELEGRAPH_COLOR)
			draw_arc(
				Vector2.ZERO,
				ATTACK_RANGE,
				0.0,
				TAU,
				48,
				Color("#ff684f"),
				3.0,
				true
			)
	elif state == State.ATTACKING:
		draw_circle(Vector2.ZERO, ATTACK_RANGE, ATTACK_COLOR)
		draw_arc(
			Vector2.ZERO,
			ATTACK_RANGE,
			0.0,
			TAU,
			48,
			Color("#ff2f22"),
			4.0,
			true
		)

	draw_circle(Vector2.ZERO, 18.0, ENEMY_COLOR)
	draw_circle(Vector2(-6.0, -4.0), 3.0, Color.WHITE)
	draw_circle(Vector2(6.0, -4.0), 3.0, Color.WHITE)
