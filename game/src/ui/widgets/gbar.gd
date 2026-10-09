class_name GBar
extends Control

var value := 0.0:
	set(v):
		value = clampf(v, 0.0, 1.0)
		queue_redraw()
var color := UI.NOW
var track := Color(UI.RULE, 0.9)


func _init(h: float = 8.0, c: Color = UI.NOW) -> void:
	custom_minimum_size.y = h
	color = c
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func animate_to(v: float, d: float = 0.6) -> Tween:
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "value", v, d)
	return tw


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), track)
	if value <= 0.0:
		return
	var w := size.x * value
	draw_rect(Rect2(0, 0, w, size.y), color)
	draw_rect(Rect2(w - 3.0, -2.0, 3.0, size.y + 4.0), UI.HOT)
