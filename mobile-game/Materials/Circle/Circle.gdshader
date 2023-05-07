shader_type canvas_item;

uniform float radius:  hint_range(0, 1) = 0.;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {	
	// black mask
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	
	float max_radius = sqrt(1. + pow(1. / ratio, 2.)) * .5;
	
	float size = max_radius * radius;
	float mask = step(size, length(scaledUV - center));
	
	if (mask == 1.) {
		COLOR.a = 0.;
	}
}

