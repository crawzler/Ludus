extends Node2D

const ARENA_SIZE: Vector2 = Vector2(960.0, 540.0)
const WALL_THICKNESS: float = 32.0

@onready var player: CharacterBody2D = $Player
@onready var enemy: CharacterBody2D = $Enemy
@onready var health_label: Label = $HUD/HealthLabel
@onready var result_label: Label = $HUD/ResultLabel

var combat_finished: bool = false


func _ready() -> void:
	player.connect("health_changed", _on_player_health_changed)
	player.connect("defeated", _on_player_defeated)
	enemy.connect("health_changed", _on_enemy_health_changed)
	enemy.connect("defeated", _on_enemy_defeated)
	_update_health_display()

	_create_boundary(
		Vector2(-WALL_THICKNESS / 2.0, ARENA_SIZE.y / 2.0),
		Vector2(WALL_THICKNESS, ARENA_SIZE.y + WALL_THICKNESS * 2.0)
	)
	_create_boundary(
		Vector2(ARENA_SIZE.x + WALL_THICKNESS / 2.0, ARENA_SIZE.y / 2.0),
		Vector2(WALL_THICKNESS, ARENA_SIZE.y + WALL_THICKNESS * 2.0)
	)
	_create_boundary(
		Vector2(ARENA_SIZE.x / 2.0, -WALL_THICKNESS / 2.0),
		Vector2(ARENA_SIZE.x + WALL_THICKNESS * 2.0, WALL_THICKNESS)
	)
	_create_boundary(
		Vector2(ARENA_SIZE.x / 2.0, ARENA_SIZE.y + WALL_THICKNESS / 2.0),
		Vector2(ARENA_SIZE.x + WALL_THICKNESS * 2.0, WALL_THICKNESS)
	)


func _create_boundary(wall_position: Vector2, wall_size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = wall_position

	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = wall_size
	collision.shape = shape
	wall.add_child(collision)
	add_child(wall)


func _on_player_health_changed(_current_health: int, _max_health: int) -> void:
	_update_health_display()


func _on_enemy_health_changed(_current_health: int, _max_health: int) -> void:
	_update_health_display()


func _update_health_display() -> void:
	health_label.text = "%s    %s" % [
		player.call("get_health_text"),
		enemy.call("get_health_text")
	]


func _on_player_defeated() -> void:
	_finish_combat(false)


func _on_enemy_defeated() -> void:
	_finish_combat(true)


func _finish_combat(player_won: bool) -> void:
	if combat_finished:
		return

	combat_finished = true
	result_label.text = "VITÓRIA" if player_won else "DERROTA"
	result_label.visible = true
	player.call("finish_combat")
	enemy.call("finish_combat")


func _draw() -> void:
	draw_rect(Rect2(-5000.0, -5000.0, 10000.0, 10000.0), Color("#17191c"))
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color("#554b42"))
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color("#d1a66d"), false, 6.0)
