shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 color: source_color = vec4(1., 1., 1., 0.8);
uniform float blur_direction: hint_range(4.0, 32.0, 0.1) = 16.0; // more is better but slower
uniform float blur_quality: hint_range(2.0, 64.0, 0.1) = 3.0; // more is better but slower
uniform float blur_size: hint_range(2.0, 32.0, 0.1) = 16.0; // compute radius with PIXEL_SIZE

vec4 blur(vec2 screen_uv, vec2 screen_pixel_size) {
	vec2 radius = blur_size * screen_pixel_size;
	
	vec4 texture_color = texture(screen_texture, screen_uv);
	int count = 0;
	for (float d = 0.; d < 2. * PI; d += PI / blur_direction) {
		for (float i = 1.0 / blur_quality; i <= 1.0; i += 1.0 / blur_quality) {
			texture_color += texture(screen_texture, screen_uv + vec2(cos(d), sin(d)) * radius * i);
			count += 1;
		}
	}
	return texture_color / float(count);
}

void fragment() {
	COLOR = blur(SCREEN_UV, SCREEN_PIXEL_SIZE);
}