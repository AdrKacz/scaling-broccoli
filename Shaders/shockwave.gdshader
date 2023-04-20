shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float force = 0.5; // 1
uniform float size;
uniform float thickness = 0.01; // 0.1
uniform float aberation = 0.5;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) * smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	
	COLOR.r = texture(SCREEN_TEXTURE, SCREEN_UV - disp * (1.0 + aberation)).r;
	COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV - disp).g;
	COLOR.b = texture(SCREEN_TEXTURE, SCREEN_UV - disp * (1.0 - aberation)).b;
	
//	COLOR.rgb = vec3(mask);
}