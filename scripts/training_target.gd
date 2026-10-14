extends Node2D

const MAX_HEALTH: int = 3
const HIT_FLASH_DURATION: float = 0.12
const TARGET_COLOR: Color = Color("#b56b45")
const HIT_COLOR: Color = Color("#fff2a6")

var health: int = MAX_HEALTH
var hit_flash_tween: Tween
var is_defeated: bool = false


func take_damage(amount: int) -> void:
	if is_defeated:
		return

	health -= amount
	_show_hit_feedback()
	if health <= 0:
		is_defeated = true
		await get_tree().create_timer(HIT_FLASH_DURATION).timeout
		queue_free()


func _show_hit_feedback() -> void:
	if hit_flash_tween and hit_flash_tween.is_running():
		hit_flash_tween.kill()
	modulate = HIT_COLOR
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(self, "modulate", Color.WHITE, HIT_FLASH_DURATION)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 22.0, TARGET_COLOR)
	draw_circle(Vector2.ZERO, 12.0, Color("#704637"))
