class_name GSegmented
extends HBoxContainer

signal changed(index: int)

var selected := 0
var _btns: Array[Button] = []


func _init(options: Array, sel: int = 0) -> void:
	selected = sel
	add_theme_constant_override("separation", 10)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for i in options.size():
		var b := Button.new()
		b.text = String(options[i]).to_upper()
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size.y = 66
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_override("font", UI.font("mono", 600, 2))
		b.add_theme_font_size_override("font_size", 18)
		b.pressed.connect(_pick.bind(i))
		add_child(b)
		_btns.append(b)
	_refresh()


func set_enabled(v: bool) -> void:
	modulate.a = 1.0 if v else 0.35
	for b in _btns:
		b.disabled = not v


func _pick(i: int) -> void:
	if i == selected:
		return
	selected = i
	_refresh()
	Audio.sfx("ui_toggle")
	Haptics.tap()
	changed.emit(i)


func _refresh() -> void:
	for i in _btns.size():
		var on := i == selected
		var s := UI.box(Color(UI.NOW, 0.14) if on else Color(UI.VOID2, 0.85), UI.NOW if on else UI.RULE, 2, 10)
		s.set_content_margin_all(10)
		var b := _btns[i]
		for st in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
			b.add_theme_stylebox_override(st, s)
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		var fc := UI.NOW if on else UI.DIM
		for st in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_disabled_color"]:
			b.add_theme_color_override(st, fc)
