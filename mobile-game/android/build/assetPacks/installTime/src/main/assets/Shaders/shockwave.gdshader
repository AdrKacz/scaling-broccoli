shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float size;
uniform float thickness = 0.1;
uniform float aberation = 0.5;
uniform float force = 1.;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) * 
		smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	
	COLOR.r = texture(screen_texture, SCREEN_UV - disp * (1.0 + aberation)).r;
	COLOR.g = texture(screen_texture, SCREEN_UV - disp).g;
	COLOR.b = texture(screen_texture, SCREEN_UV - disp * (1.0 - aberation)).b;
}