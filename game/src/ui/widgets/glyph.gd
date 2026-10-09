class_name Glyph
extends Control

var shape := "play"
var color := UI.INK
var width := 4.0


func _init(s: String = "play", c: Color = UI.INK, px: float = 40.0) -> void:
	shape = s
	color = c
	custom_minimum_size = Vector2(px, px)
	size = custom_minimum_size
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	width = maxf(2.5, px * 0.09)


func set_shape(s: String, c: Color = color) -> void:
	shape = s
	color = c
	queue_redraw()


func _draw() -> void:
	var c := size * 0.5
	var u := minf(size.x, size.y) * 0.5
	match shape:
		"play":
			draw_colored_polygon(_pts([Vector2(-0.42, -0.62), Vector2(0.66, 0), Vector2(-0.42, 0.62)], c, u), color)
		"pause":
			draw_rect(Rect2(c + Vector2(-0.48, -0.58) * u, Vector2(0.3, 1.16) * u), color)
			draw_rect(Rect2(c + Vector2(0.18, -0.58) * u, Vector2(0.3, 1.16) * u), color)
		"back":
			_line([Vector2(0.22, -0.6), Vector2(-0.36, 0), Vector2(0.22, 0.6)], c, u)
		"next":
			_line([Vector2(-0.22, -0.6), Vector2(0.36, 0), Vector2(-0.22, 0.6)], c, u)
		"close":
			_line([Vector2(-0.5, -0.5), Vector2(0.5, 0.5)], c, u)
			_line([Vector2(0.5, -0.5), Vector2(-0.5, 0.5)], c, u)
		"check":
			_line([Vector2(-0.55, 0.02), Vector2(-0.15, 0.42), Vector2(0.6, -0.45)], c, u)
		"retry":
			draw_arc(c, 0.55 * u, -PI * 0.25, PI * 1.45, 32, color, width, true)
			var tip := c + Vector2.from_angle(-PI * 0.25) * 0.55 * u
			draw_colored_polygon(PackedVector2Array([tip + Vector2(-0.05, -0.38) * u, tip + Vector2(0.34, 0.06) * u, tip + Vector2(-0.18, 0.18) * u]), color)
		"home":
			_line([Vector2(-0.6, -0.02), Vector2(0, -0.6), Vector2(0.6, -0.02)], c, u)
			_line([Vector2(-0.42, -0.14), Vector2(-0.42, 0.58), Vector2(0.42, 0.58), Vector2(0.42, -0.14)], c, u)
		"gear":
			draw_arc(c, 0.36 * u, 0, TAU, 32, color, width, true)
			for i in 8:
				var a := TAU * i / 8.0
				draw_line(c + Vector2.from_angle(a) * 0.48 * u, c + Vector2.from_angle(a) * 0.74 * u, color, width * 1.5, true)
		"trophy":
			_line([Vector2(-0.46, -0.6), Vector2(0.46, -0.6), Vector2(0.4, -0.08), Vector2(0, 0.18), Vector2(-0.4, -0.08), Vector2(-0.46, -0.6)], c, u)
			_line([Vector2(0, 0.18), Vector2(0, 0.46)], c, u)
			_line([Vector2(-0.34, 0.6), Vector2(0.34, 0.6)], c, u)
			draw_arc(c + Vector2(-0.5, -0.36) * u, 0.2 * u, PI * 0.5, PI * 1.5, 12, color, width * 0.8, true)
			draw_arc(c + Vector2(0.5, -0.36) * u, 0.2 * u, -PI * 0.5, PI * 0.5, 12, color, width * 0.8, true)
		"star":
			draw_colored_polygon(_star(c, u * 0.9), color)
		"star_o":
			var s := _star(c, u * 0.9)
			s.append(s[0])
			draw_polyline(s, color, width * 0.7, true)
		"lock":
			draw_rect(Rect2(c + Vector2(-0.5, -0.1) * u, Vector2(1.0, 0.72) * u), color)
			draw_arc(c + Vector2(0, -0.12) * u, 0.32 * u, PI, TAU, 16, color, width, true)
		"skins":
			draw_circle(c + Vector2(0.18, -0.18) * u, 0.22 * u, color, true, -1.0, true)
			draw_arc(c, 0.62 * u, PI * 0.15, PI * 1.85, 32, color, width, true)
		"infinity":
			draw_arc(c + Vector2(-0.3, 0) * u, 0.3 * u, 0, TAU, 24, color, width, true)
			draw_arc(c + Vector2(0.3, 0) * u, 0.3 * u, 0, TAU, 24, color, width, true)
		"calendar":
			draw_rect(Rect2(c + Vector2(-0.56, -0.44) * u, Vector2(1.12, 1.0) * u), color, false, width)
			draw_rect(Rect2(c + Vector2(-0.56, -0.44) * u, Vector2(1.12, 0.26) * u), color)
			_line([Vector2(-0.3, -0.66), Vector2(-0.3, -0.4)], c, u)
			_line([Vector2(0.3, -0.66), Vector2(0.3, -0.4)], c, u)
			draw_rect(Rect2(c + Vector2(0.08, 0.1) * u, Vector2(0.26, 0.24) * u), color)
		"grid":
			for i in 4:
				var o := Vector2(-0.56 + (i % 2) * 0.66, -0.56 + (i / 2) * 0.66)
				draw_rect(Rect2(c + o * u, Vector2(0.46, 0.46) * u), color, i == 0, width * 0.8)
		"shard":
			var d := _pts([Vector2(0, -0.7), Vector2(0.46, 0), Vector2(0, 0.7), Vector2(-0.46, 0)], c, u)
			draw_colored_polygon(d, Color(color, 0.35))
			d.append(d[0])
			draw_polyline(d, color, width * 0.7, true)
		"echo":
			draw_arc(c, 0.45 * u, 0, TAU, 32, color, width * 1.3, true)
			draw_arc(c + Vector2(-0.34, 0) * u, 0.45 * u, PI * 0.6, PI * 1.4, 16, Color(color, 0.45), width * 0.8, true)
		"bolt":
			draw_colored_polygon(_pts([Vector2(0.12, -0.7), Vector2(-0.42, 0.1), Vector2(-0.02, 0.1), Vector2(-0.14, 0.7), Vector2(0.42, -0.1), Vector2(0.02, -0.1)], c, u), color)
		"vibrate":
			draw_rect(Rect2(c + Vector2(-0.26, -0.56) * u, Vector2(0.52, 1.12) * u), color, false, width)
			_line([Vector2(-0.52, -0.3), Vector2(-0.52, 0.3)], c, u)
			_line([Vector2(0.52, -0.3), Vector2(0.52, 0.3)], c, u)


func _pts(a: Array, c: Vector2, u: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in a:
		out.append(c + p * u)
	return out


func _line(a: Array, c: Vector2, u: float) -> void:
	draw_polyline(_pts(a, c, u), color, width, true)


func _star(c: Vector2, r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 10:
		var a := -PI * 0.5 + i * PI / 5.0
		pts.append(c + Vector2.from_angle(a) * (r if i % 2 == 0 else r * 0.45))
	return pts
