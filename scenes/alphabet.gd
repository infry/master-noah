@tool
extends Node2D

@export_group("Text Settings")
@export_multiline() var text:String = "":
	set(value):
		text = value
		update_text(value)

@export var horizontal_alignment: HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT:
	set(v):
		horizontal_alignment = v
		update_text(text)

@export_group("Glyph Settings")
@export var sprite_frames:SpriteFrames = preload("res://assets/fonts/alphabet.res"):
	set(value):
		sprite_frames = value
		update_text(text)

## ex. " bold"
@export var forced_anim_suffix:String = "":
	set(value):
		forced_anim_suffix = value
		update_text(text)

@export var line_gap:float = 70.0:
	set(value):
		line_gap = value
		update_text(value)

@export var default_character_gap:float = 0.0:
	set(value):
		default_character_gap = value
		update_text(text)

@export_subgroup("Overrides")
@export var character_gap:Dictionary[String, float] = { " ": 40.0 }:
	set(value):
		character_gap = value
		update_text(text)

@export var character_offsets:Dictionary[String, Vector2] = {
	"g": Vector2(0, 15),
	"j": Vector2(0, 15),
	"p": Vector2(0, 15),
	"q": Vector2(0, 15),
	"y": Vector2(0, 15)
}:
	set(value):
		character_offsets = value
		update_text(text)

@export var glyph_name_overrides:Dictionary[String, StringName] = {
	"&": &"amp",
	"😠": &"angry faic",
	"'": &"apostraphie",
	",": &"comma",
	"$": &"dollarsign",
	"↓": &"down arrow",
	"”": &"end parentheses",
	"!": &"exclamation point",
	"/": &"forward slash",
	"#": &"hashtag ",
	"♥": &"heart",
	"♡": &"heart",
	"←": &"left arrow",
	"*": &"multiply x",
	".": &"period",
	"?": &"question mark",
	"→": &"right arrow",
	"“": &"start parentheses",
	"↑": &"up arrow",
}:
	set(value):
		glyph_name_overrides = value
		update_text(text)


func get_suffix(character:String) -> StringName:
	if forced_anim_suffix != &"" and sprite_frames.has_animation(character + forced_anim_suffix):
		return forced_anim_suffix
	if sprite_frames.has_animation(character):
		return &""
	if character == character.to_upper() and sprite_frames.has_animation(character + &" capital"):
		return &" capital"
	if character == character.to_lower() and sprite_frames.has_animation(character + &" lowercase"):
		return &" lowercase"
	
	return &""


func get_glyph_name(character: String) -> StringName:
	return glyph_name_overrides.get(character, character) + get_suffix(character)

func get_glyph_texture(glyph: String) -> Texture2D:
	if sprite_frames and sprite_frames.has_animation(glyph):
		return sprite_frames.get_frame_texture(glyph, 0)
	
	return null

## Returns the width of the string's characters
func get_string_width(line: String) -> float:
	var sum: float = 0
	
	for c in line:
		var glyph_name: StringName = get_glyph_name(c)
		var glyph_texture: Texture2D = get_glyph_texture(glyph_name)
		if glyph_texture:
			sum += glyph_texture.get_width()
		
		sum += character_gap.get(c, default_character_gap)
	
	return sum


func update_text(new_text):
	for glyph in get_children():
		glyph.queue_free()
	
	if new_text.is_empty():
		return
	
	var characters = new_text.split()
	
	var next_x:float
	
	match horizontal_alignment:
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER:
			next_x = -get_string_width(new_text) / 2
		
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT:
			next_x = -get_string_width(new_text)
		
		_:
			next_x = 0
	
	for i in characters.size():
		var character: String = characters[i]
		var glyph: AnimatedSprite2D = AnimatedSprite2D.new()
		glyph.sprite_frames = sprite_frames
		glyph.centered = false
		
		var glyph_name: StringName = get_glyph_name(character)
		if sprite_frames.has_animation(glyph_name):
			glyph.play(glyph_name)
			sprite_frames.set_animation_loop(glyph_name, true)
		
		glyph.offset = character_offsets.get(character, Vector2(0.0, 0.0))
		self.add_child(glyph)
		
		glyph.position.x = next_x
		
		next_x = glyph.position.x
		next_x += character_gap.get(character, default_character_gap)
		
		var glyph_texture: Texture2D = get_glyph_texture(glyph_name)
		
		if glyph_texture:
			next_x += glyph_texture.get_width()
			glyph.position.y -= glyph_texture.get_height()
