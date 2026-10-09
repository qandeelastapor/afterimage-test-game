class_name UI
extends RefCounted

const VOID := Color("07060d")
const VOID2 := Color("13101f")
const PANEL := Color("17132a")
const RULE := Color("2a2542")
const NOW := Color("ffb03b")
const HOT := Color("fff3dc")
const ECHO := Color("3ad6e8")
const DEEP := Color("5a6dff")
const VIOLET := Color("b46bff")
const INK := Color("eeeaf7")
const DIM := Color("8d88a9")
const DANGER := Color("ff3d6e")
const GOOD := Color("5dffb0")

static var _fonts: Dictionary = {}
static var _glow: Texture2D


static func font(kind: String = "mono", weight: int = 400, spacing: int = 0) -> Font:
	var key := "%s/%d/%d" % [kind, weight, spacing]
	if _fonts.has(key):
		return _fonts[key]
	var fv := new_font(kind, weight, spacing)
	_fonts[key] = fv
	return fv


static func new_font(kind: String = "mono", weight: int = 400, spacing: int = 0) -> FontVariation:
	var fv := FontVariation.new()
	var path := "res://assets/fonts/Michroma-Regular.ttf" if kind == "display" else "res://assets/fonts/MartianMono.ttf"
	if ResourceLoader.exists(path):
		fv.base_font = load(path)
	if kind != "display":
		fv.variation_opentype = {"wght": weight}
	fv.spacing_glyph = spacing
	return fv


static func label(text: String, size: int = 24, color: Color = INK, kind: String = "mono", weight: int = 400, spacing: int = 0) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", font(kind, weight, spacing))
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func caps(text: String, size: int = 18, color: Color = DIM, weight: int = 500) -> Label:
	return label(text.to_upper(), size, color, "mono", weight, 3)


static func para(text: String, size: int = 20, color: Color = DIM) -> Label:
	var l := label(text, size, color, "mono", 400)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_constant_override("line_spacing", 6)
	return l


static func box(bg: Color, border: Color = Color.TRANSPARENT, bw: int = 0, radius: int = 14, chamfer: bool = true, skew: float = 0.0) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(radius)
	s.corner_detail = 1 if chamfer else 10
	s.skew = Vector2(skew, 0.0)
	s.anti_aliasing = true
	s.set_content_margin_all(18)
	return s


static func panel(bg: Color = PANEL, border: Color = RULE, pad: int = 26) -> PanelContainer:
	var p := PanelContainer.new()
	var s := box(bg, border, 2, 18)
	s.set_content_margin_all(pad)
	p.add_theme_stylebox_override("panel", s)
	return p


static func vbox(sep: int = 16) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", sep)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return v


static func hbox(sep: int = 16) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", sep)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return h


static func spacer(min_h: float = 0.0, expand: bool = true) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, min_h)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if expand:
		c.size_flags_vertical = Control.SIZE_EXPAND_FILL
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return c


static func passthrough(n: Node) -> void:
	if n is Control and not (n is BaseButton) and not (n is Range) and not (n is ScrollContainer):
		(n as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	for c in n.get_children():
		passthrough(c)


static func glow_tex() -> Texture2D:
	if _glow:
		return _glow
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	g.add_point(0.16, Color(1, 1, 1, 0.45))
	g.add_point(0.45, Color(1, 1, 1, 0.1))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 128
	t.height = 128
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	_glow = t
	return t


static func disc_tex(r: int, col: Color) -> ImageTexture:
	var s := r * 2 + 2
	var img := Image.create_empty(s, s, false, Image.FORMAT_RGBA8)
	var c := Vector2(s, s) * 0.5
	for y in s:
		for x in s:
			var d := Vector2(x + 0.5, y + 0.5).distance_to(c)
			img.set_pixel(x, y, Color(col, col.a * clampf(r - d + 0.5, 0.0, 1.0)))
	return ImageTexture.create_from_image(img)


static func is_mobile() -> bool:
	return OS.has_feature("mobile")


static func safe_rect(vp: Viewport) -> Rect2:
	var vs := vp.get_visible_rect().size
	var ws := Vector2(DisplayServer.window_get_size())
	if not is_mobile() or ws.x <= 0.0:
		return Rect2(Vector2.ZERO, vs)
	var sa := Rect2(DisplayServer.get_display_safe_area())
	var k := vs / ws
	return Rect2(sa.position * k, sa.size * k)


static func safe_top(vp: Viewport) -> float:
	return maxf(0.0, safe_rect(vp).position.y)


static func safe_bottom(vp: Viewport) -> float:
	var vs := vp.get_visible_rect().size
	return clampf(vs.y - safe_rect(vp).end.y, 0.0, 120.0)


static func fmt(n: int) -> String:
	var s := str(absi(n))
	var out := ""
	while s.length() > 3:
		out = "," + s.substr(s.length() - 3) + out
		s = s.substr(0, s.length() - 3)
	return ("-" if n < 0 else "") + s + out


static func build_theme() -> Theme:
	var t := Theme.new()
	t.default_font = font("mono", 400)
	t.default_font_size = 24
	t.set_color("font_color", "Label", INK)
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	t.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())
	t.set_stylebox("panel", "PanelContainer", box(PANEL, RULE, 2, 18))

	var bar := box(Color(RULE, 0.0), Color.TRANSPARENT, 0, 4, false)
	bar.set_content_margin_all(2)
	var grab := box(Color(DIM, 0.35), Color.TRANSPARENT, 0, 4, false)
	grab.set_content_margin_all(3)
	for sb in ["VScrollBar", "HScrollBar"]:
		t.set_stylebox("scroll", sb, bar)
		t.set_stylebox("grabber", sb, grab)
		t.set_stylebox("grabber_highlight", sb, grab)
		t.set_stylebox("grabber_pressed", sb, grab)

	var track := box(RULE, Color.TRANSPARENT, 0, 5, false)
	track.content_margin_top = 5
	track.content_margin_bottom = 5
	var fill := box(NOW, Color.TRANSPARENT, 0, 5, false)
	fill.content_margin_top = 5
	fill.content_margin_bottom = 5
	t.set_stylebox("slider", "HSlider", track)
	t.set_stylebox("grabber_area", "HSlider", fill)
	t.set_stylebox("grabber_area_highlight", "HSlider", fill)
	t.set_icon("grabber", "HSlider", disc_tex(17, HOT))
	t.set_icon("grabber_highlight", "HSlider", disc_tex(19, HOT))
	t.set_icon("grabber_disabled", "HSlider", disc_tex(17, DIM))
	return t
