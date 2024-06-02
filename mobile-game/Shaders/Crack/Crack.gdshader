shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 refraction_offset = vec2(-25., -25.);
uniform vec2 reflection_offset = vec2(1., 1.);
uniform vec4 reflection_color: source_color = vec4(1., 1., 1., .8);

const vec4 WHITE = vec4(1.);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 adjacent_color = texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * reflection_offset);
	vec4 refraction_color = texture(screen_texture, SCREEN_UV + SCREEN_PIXEL_SIZE * refraction_offset);
	
	COLOR = mix(reflection_color, refraction_color, adjacent_color.a) * color.a;
}
