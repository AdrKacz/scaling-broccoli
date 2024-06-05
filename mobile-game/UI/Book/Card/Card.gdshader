shader_type canvas_item;
uniform sampler2D image_texture;
vec2 scaled_vector(vec2 vector, float pixel_ratio) {
	return (vector - vec2(0., 0.5)) / vec2(1.0, pixel_ratio) + vec2(0., 0.5);
}

void fragment() {
	ivec2 texture_size = textureSize(image_texture, 0);
	float pixel_ratio = float(texture_size.x) / float(texture_size.y);
	vec2 scaled_uv = scaled_vector(UV, pixel_ratio);
	if (COLOR == vec4(0., 0., 0., 1.))
		COLOR = texture(image_texture, scaled_uv);
}