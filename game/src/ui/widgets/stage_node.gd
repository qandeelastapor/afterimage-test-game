class_name StageNode
extends Button

var number := 1
var stars := 0
var locked := false
var current := false
var accent := UI.ECHO
var _t := 0.0


func _init(n: int, s: int, is_locked: bool, is_current: bool, c: Color) -> void:
	number = n
	stars = s
	locked = is_locked
	current = is_current
	accent = c
	custom_minimum_size = Vector2(118, 142)
	focus_mode = Control.FOCUS_NONE
	disabled = locked
	flat = true
	for st in ["normal", "hover", "pressed", "hover_pressed", "disabled", "focus"]:
		add_theme_stylebox_override(st, StyleBoxEmpty.new())


func _ready() -> void:
	button_down.connect(func() -> void: scale = Vector2(0.92, 0.92))
	button_up.connect(func() -> void: create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(self, "scale", Vector2.ONE, 0.25))
	resized.connect(func() -> void: pivot_offset = size * 0.5)
	pressed.connect(func() -> void:
		Audio.sfx("ui_tap")
		Haptics.tap())


func _process(delta: float) -> void:
	if current:
		_t += delta
		queue_redraw()


func _draw() -> void:
	var c := Vector2(size.x * 0.5, 50)
	var r := 42.0
	if locked:
		draw_arc(c, r, 0, TAU, 48, Color(UI.RULE, 1.0), 3.0, true)
		var lock := Rect2(c + Vector2(-11, -4), Vector2(22, 17))
		draw_rect(lock, UI.DIM)
		draw_arc(c + Vector2(0, -4), 8, PI, TAU, 12, UI.DIM, 3.0, true)
		return
	var cleared := stars > 0
	draw_circle(c, r, Color(accent, 0.16 if cleared else 0.06), true, -1.0, true)
	draw_arc(c, r, 0, TAU, 48, accent if cleared or current else Color(accent, 0.5), 3.0, true)
	if current:
		var k := fposmod(_t, 1.4) / 1.4
		draw_arc(c, r + 6.0 + k * 16.0, 0, TAU, 48, Color(UI.NOW, 0.8 * (1.0 - k)), 3.0, true)
	var f := UI.font("display")
	var s := str(number)
	var w := f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, 30).x
	draw_string(f, c + Vector2(-w * 0.5, 11), s, HORIZONTAL_ALIGNMENT_LEFT, -1, 30, UI.HOT if cleared or current else UI.INK)
	for i in 3:
		var p := Vector2(size.x * 0.5 + (i - 1) * 26.0, 116)
		_star(p, 10.0, i < stars)


func _star(c: Vector2, r: float, fill: bool) -> void:
	var pts := PackedVector2Array()
	for i in 10:
		pts.append(c + Vector2.from_angle(-PI * 0.5 + i * PI / 5.0) * (r if i % 2 == 0 else r * 0.45))
	if fill:
		draw_colored_polygon(pts, UI.NOW)
	else:
		pts.append(pts[0])
		draw_polyline(pts, Color(UI.DIM, 0.6), 2.0, true)
