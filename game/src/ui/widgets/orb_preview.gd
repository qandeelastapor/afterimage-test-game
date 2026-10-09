class_name OrbPreview
extends Control

var skin: Dictionary
var locked := false
var _t := 0.0


func _init(s: Dictionary) -> void:
	skin = s
	custom_minimum_size = Vector2(0, 200)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _draw() -> void:
	var c := size * 0.5
	var r := minf(size.x, size.y) * 0.3
	var col := SkinDB.core_color(skin, _t)
	var ec := SkinDB.echo_color(col)
	if locked:
		col = Color(col, 0.35)
		ec = Color(ec, 0.35)
	var a0 := _t * 1.6
	var pts := PackedVector2Array()
	var cols := PackedColorArray()
	for i in 40:
		var k := i / 39.0
		var a := a0 - k * 3.4
		pts.append(c + Vector2(cos(a), sin(a) * 0.62) * r)
		var cc := col.lerp(ec, minf(1.0, k * 1.6))
		cc.a *= 0.75 * (1.0 - k) + 0.05
		cols.append(cc)
	draw_polyline_colors(pts, cols, 4.0, true)
	var g := UI.glow_tex()
	var ep := c + Vector2(cos(a0 - 2.1), sin(a0 - 2.1) * 0.62) * r
	draw_texture_rect(g, Rect2(ep - Vector2(46, 46), Vector2(92, 92)), false, Color(ec, 0.5 * ec.a))
	draw_arc(ep, 12, 0, TAU, 32, ec, 3.0, true)
	draw_circle(ep, 6, UI.VOID, true, -1.0, true)
	var p := pts[0]
	draw_texture_rect(g, Rect2(p - Vector2(64, 64), Vector2(128, 128)), false, Color(col, 0.75 * col.a))
	draw_circle(p, 8, Color(UI.HOT, col.a), true, -1.0, true)
	draw_arc(p, 13, 0, TAU, 32, col, 3.0, true)
