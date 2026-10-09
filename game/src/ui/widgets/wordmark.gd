class_name Wordmark
extends Control

const ECHO_ALPHA := [0.55, 0.3, 0.15]

var text := "AFTERIMAGE"
var font_size := 56
var main: Label
var echoes: Array[Label] = []
var font: FontVariation
var spread := 1.0
var _t := 0.0


func _init(t: String = "AFTERIMAGE", fs: int = 56) -> void:
	text = t
	font_size = fs
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(0, fs * 1.45)
	font = UI.new_font("display", 400, int(fs * 0.05))


func _ready() -> void:
	for i in 3:
		echoes.append(_make(Color(UI.ECHO if i < 2 else UI.DEEP, ECHO_ALPHA[i])))
	main = _make(UI.HOT)


func _make(c: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", font)
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", c)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.set_anchors_preset(Control.PRESET_FULL_RECT)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(l)
	return l


func _process(delta: float) -> void:
	_t += delta
	var sway := sin(_t * 1.3) * 0.25
	for i in echoes.size():
		var off := -(i + 1) * font_size * 0.085 * spread * (1.0 + sway * (i + 1) * 0.25)
		echoes[i].position = Vector2(off, sin(_t * 1.7 + i) * 1.5 * spread)


func animate_in(delay: float = 0.0) -> void:
	spread = 0.0
	main.modulate.a = 0.0
	main.scale = Vector2(1.08, 1.08)
	main.pivot_offset = size * 0.5
	var tw := create_tween().set_parallel(true)
	tw.tween_property(main, "modulate:a", 1.0, 0.5).set_delay(delay)
	tw.tween_property(main, "scale", Vector2.ONE, 0.7).set_delay(delay).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "spread", 1.0, 0.9).set_delay(delay + 0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
