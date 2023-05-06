shader_type canvas_item;

uniform float radius_percentage:  hint_range(0, 1) = 0.;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {	
	// mask
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	
	float max_radius = sqrt(1. + pow(1. / ratio, 2.)) * .5;
	
	float circle_size = max_radius * radius_percentage;
	float circle_mask = step(circle_size, length(scaledUV - center));
	
	float mask = 1. - circle_mask;

	// apply black and white filter
	vec4 pixel = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = mask * (1. - ceil(pixel.rgb)) + (1. - mask) * pixel.rgb;
}
