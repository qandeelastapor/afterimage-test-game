class_name GToggle
extends Control

signal toggled(on: bool)

var on := false
var _k := 0.0


func _init(v: bool = false) -> void:
	on = v
	_k = 1.0 if v else 0.0
	custom_minimum_size = Vector2(100, 54)
	mouse_filter = Control.MOUSE_FILTER_STOP


func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and not e.pressed:
		if Rect2(Vector2.ZERO, size).has_point(e.position):
			set_on(not on, true)
			accept_event()


func set_on(v: bool, notify: bool = false) -> void:
	on = v
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_method(_set_k, _k, 1.0 if on else 0.0, 0.22)
	if notify:
		Audio.sfx("ui_toggle")
		Haptics.tap()
		toggled.emit(on)


func _set_k(v: float) -> void:
	_k = v
	queue_redraw()


func _draw() -> void:
	var r := size.y * 0.5
	var track := UI.box(UI.RULE.lerp(Color(UI.NOW, 0.9), clampf(_k, 0.0, 1.0)), Color.TRANSPARENT, 0, int(r), false)
	draw_style_box(track, Rect2(Vector2.ZERO, size))
	var x := r + (size.x - r * 2.0) * _k
	draw_circle(Vector2(x, r), r - 7.0, UI.VOID if on else UI.INK, true, -1.0, true)
