extends Node2D

const ARENA_SIZE: Vector2 = Vector2(960.0, 540.0)
const WALL_THICKNESS: float = 32.0


func _ready() -> void:
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


func _draw() -> void:
	draw_rect(Rect2(-5000.0, -5000.0, 10000.0, 10000.0), Color("#17191c"))
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color("#554b42"))
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color("#d1a66d"), false, 6.0)
