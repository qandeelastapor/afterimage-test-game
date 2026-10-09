class_name GButton
extends Button

enum { PRIMARY, SECONDARY, GHOST, ROUND }

var kind := SECONDARY
var glyph: Glyph
var accent := UI.NOW
var sound := "ui_tap"
var _tw: Tween


func _init(t: String = "", k: int = SECONDARY, g: String = "", min_size: Vector2 = Vector2.ZERO) -> void:
	text = t
	kind = k
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = min_size
	if g != "":
		var px := 30.0 if k == ROUND else 34.0
		glyph = Glyph.new(g, UI.VOID if k == PRIMARY else UI.INK, px)


func _ready() -> void:
	restyle()
	if glyph:
		add_child(glyph)
	resized.connect(_layout)
	_layout()
	button_down.connect(_on_down)
	button_up.connect(_on_up)
	pressed.connect(_on_pressed)


func restyle() -> void:
	var n: StyleBoxFlat
	var p: StyleBoxFlat
	var f: Font
	var fs := 22
	var fc := UI.INK
	match kind:
		PRIMARY:
			n = UI.box(accent, Color.TRANSPARENT, 0, 12, true, 0.16)
			n.shadow_color = Color(UI.ECHO, 0.6)
			n.shadow_offset = Vector2(-9, 0)
			n.shadow_size = 1
			n.content_margin_left = 40
			n.content_margin_right = 40
			p = n.duplicate()
			p.bg_color = UI.HOT
			p.shadow_offset = Vector2(-3, 0)
			f = UI.font("display")
			fs = 30
			fc = UI.VOID
		SECONDARY:
			n = UI.box(Color(UI.VOID2, 0.86), UI.RULE, 2, 12)
			p = n.duplicate()
			p.border_color = accent
			p.bg_color = UI.PANEL
			f = UI.font("mono", 600, 3)
		GHOST:
			n = UI.box(Color(UI.INK, 0.0), Color.TRANSPARENT, 0, 12)
			p = UI.box(Color(UI.INK, 0.07), Color.TRANSPARENT, 0, 12)
			f = UI.font("mono", 500, 3)
			fs = 19
			fc = UI.DIM
		_:
			n = UI.box(Color(UI.VOID2, 0.8), UI.RULE, 2, 999, false)
			p = n.duplicate()
			p.border_color = accent
			f = UI.font("mono", 500)
			fs = 20
	var d := n.duplicate()
	d.bg_color = Color(d.bg_color, d.bg_color.a * 0.5)
	for s in ["normal", "hover"]:
		add_theme_stylebox_override(s, n)
	for s in ["pressed", "hover_pressed"]:
		add_theme_stylebox_override(s, p)
	add_theme_stylebox_override("disabled", d)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	add_theme_font_override("font", f)
	add_theme_font_size_override("font_size", fs)
	for s in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_focus_color"]:
		add_theme_color_override(s, fc)
	add_theme_color_override("font_disabled_color", Color(fc, 0.4))


func _layout() -> void:
	pivot_offset = size * 0.5
	if glyph:
		var gs := glyph.custom_minimum_size
		glyph.size = gs
		if text == "":
			glyph.position = (size - gs) * 0.5
		else:
			glyph.position = Vector2(26, (size.y - gs.y) * 0.5)


func _on_down() -> void:
	_scale_to(Vector2(0.94, 0.94), 0.07, Tween.TRANS_QUAD)


func _on_up() -> void:
	_scale_to(Vector2.ONE, 0.26, Tween.TRANS_BACK)


func _on_pressed() -> void:
	Audio.sfx(sound)
	Haptics.tap()


func _scale_to(v: Vector2, d: float, tr: int) -> void:
	if _tw:
		_tw.kill()
	_tw = create_tween().set_trans(tr).set_ease(Tween.EASE_OUT)
	_tw.tween_property(self, "scale", v, d)


func add_content(node: Control) -> void:
	node.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(node)
	UI.passthrough(node)
