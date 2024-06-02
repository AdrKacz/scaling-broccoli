shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 refraction_offset = vec2(-25., -25.);
uniform vec2 reflection_offset = vec2(1., 1.);
uniform vec4 reflection_color: source_color = vec4(1., 1., 1., .8);
uniform float visible_proportion: hint_range(0, 1) = .5;

const vec2 CENTER = vec2(.5, .5);

void fragment() {
	// Crack
	vec4 color = texture(TEXTURE, UV);
	vec4 adjacent_color = texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * reflection_offset);
	vec4 refraction_color = texture(screen_texture, SCREEN_UV + SCREEN_PIXEL_SIZE * refraction_offset);
	
	COLOR = mix(reflection_color, refraction_color, adjacent_color.a) * color.a;
	
	// Mask
	float screen_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaled_UV = (SCREEN_UV - vec2(.5, 0.)) / vec2(screen_ratio, 1.) + vec2(.5, 0.);
	float max_radius = sqrt(1. + pow(1. / screen_ratio, 2.)) * .5;
	float size = max_radius * pow(visible_proportion, 1) ;
	float mask = step(size, length(scaled_UV - CENTER));
	
	if (mask < .0001)
		COLOR.a = 0.;
}
