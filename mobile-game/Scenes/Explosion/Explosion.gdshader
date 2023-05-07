shader_type canvas_item;

uniform float black_radius:  hint_range(0, 1) = 0.;
uniform float color_radius:  hint_range(0, 1) = 0.;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {	
	// black mask
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	
	float max_radius = sqrt(1. + pow(1. / ratio, 2.)) * .5;
	
	float black_circle_size = max_radius * black_radius;
	float black_circle_mask = step(black_circle_size, length(scaledUV - center));
	float black_mask = 1. - black_circle_mask;
	
	float color_circle_size = max_radius * color_radius;
	float color_circle_mask = step(color_circle_size, length(scaledUV - center));
	float color_mask = 1. - color_circle_mask;

	// apply black mask
	vec4 pixel = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = black_mask * (1. - ceil(pixel.rgb)) + (1. - black_mask) * pixel.rgb;
}
