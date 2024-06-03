shader_type canvas_item;

uniform float seed: hint_range(0.0, 1.0, 0.01) = 0.12345678;
uniform bool use_cracks_and_glass = true;
uniform bool use_color = true;
uniform vec4 color: source_color = vec4(0.584314, 0.345098, 0.945098, 1.);
uniform float zoom: hint_range(0.5, 1., 0.01) = 1.;

group_uniforms Cracks.Sprite;
uniform float resolution: hint_range(2, 128, .1) = 128.;
uniform bool use_pixel = true;
uniform float minimum_circle_radius: hint_range(0.01, 0.5, 0.01) = 0.15;
uniform float maximum_circle_radius: hint_range(0.01, 0.5, 0.01) = 0.5;
uniform int current_number_of_circles: hint_range(0, 6, 1) = 2;
uniform int final_number_of_circles: hint_range(4, 6, 1) = 5;
uniform int number_of_lines: hint_range(0, 20, 1) = 15; // final number of lines between 15 and 20 for best results
group_uniforms;

group_uniforms Cracks.Lighting;
uniform vec2 refraction_offset = vec2(-16., -16.);
uniform vec2 reflection_offset = vec2(4., 4.);
uniform vec4 reflection_color: source_color = vec4(1., 1., 1., 1.);
group_uniforms;

group_uniforms Glass;
uniform float blur_direction: hint_range(4.0, 32.0, 0.1) = 16.0; // more is better but slower
uniform float blur_quality: hint_range(2.0, 64.0, 0.1) = 3.0; // more is better but slower
uniform float blur_size: hint_range(2.0, 32.0, 0.1) = 16.0; // compute radius with PIXEL_SIZE
group_uniforms;

group_uniforms ChromaticAbberation;
uniform int abberation_levels: hint_range(2, 5, 1) = 3;
uniform float abberation_spread: hint_range(0.0, 0.1, 0.01) = 0.1; // set to 0.0 to disable abberation
group_uniforms;

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

float or(float a, float b) {
  return min(a + b, 1.0);
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), cos(angle)), vec2(-cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

vec2 scaled_vector(vec2 vector, float pixel_ratio) {
	return (vector - vec2(0.5, 0.0)) / vec2(pixel_ratio, 1.0) + vec2(0.5, 0.0);
}

float arc(vec2 position, vec2 origin, float radius, float width, float feather, float to_angle, float rotation) {
	vec2 vector = rotate(position, origin, rotation) - origin;
	float angle = (atan(vector.x, vector.y) + PI);

	float in_circle = smoothstep(radius, radius + feather, length(vector));
	float out_circle = smoothstep(radius + width, radius + width + feather, length(vector));
	return when_lt(angle, to_angle) * (in_circle - out_circle);
}

float line(vec2 p1, vec2 p2, float width, vec2 uv, vec2 screen_pixel_size)
{
	float dist = distance(p1, p2); // Distance between points
	float dist_uv = distance(p1, uv); // Distance from p1 to current pixel

	// If point is on line, according to dist, it should match current UV
	return 1.0 - floor(1.0 - (screen_pixel_size.x * width) + distance (mix(p1, p2, clamp(dist_uv / dist, 0.0, 1.0)),  uv));
}

float random_float (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 100000. * (1. + seed));
}

float crack(vec2 uv, vec2 screen_pixel_size) {
	uv = float(use_pixel) * (round(uv * resolution) / resolution) + (1. - float(use_pixel)) * uv;
	float value = 0.;
	
	// Add circles (radius between 0 excluded and 0.5 included)
	float radius_step = (maximum_circle_radius - minimum_circle_radius) / float(final_number_of_circles - 1);
	for (int i = 0; i < current_number_of_circles; i++) {
		float index = float(i + 1);
		vec2 offset = vec2(
			mod(random_float(vec2(.8721 * seed * index)), .02) - .01,
			mod(random_float(vec2(.1837 * seed * index)), .02) - .01
		);

		float radius = minimum_circle_radius + radius_step * (index - 1.);
		radius += mod(random_float(vec2(.1204 * seed * index)), 0.02) - 0.01;
		radius = max(0.01, radius);
		
		float angle = random_float(vec2(.8294 * seed * index)) * 2. * PI;
		float rotation = random_float(vec2(.0185 * seed * index)) * 2. * PI;
		value = or(value, arc(uv, vec2(.5) + offset, radius, 0.02, 0.005, angle, rotation));
	}
	
	// Add lines
	for (int i = 0; i < number_of_lines; i++) {
		float index = 1. * float(i);
		
		float distance_a = max(0.01, random_float(vec2(.9128 * seed * index)) * .5);
		float distance_b = max(0.01, random_float(vec2(.1049 * seed * index)) * .5);
		
		float angle = random_float(vec2(.3159 * seed * index)) * 2. * PI;
		vec2 angle_vector = vec2(cos(angle), sin(angle));
		
		vec2 point_a = vec2(.5) + distance_a * angle_vector + vec2(
			mod(random_float(vec2(.7143 * seed * index)), .02) - .01,
			mod(random_float(vec2(.2371 * seed * index)), .02) - .01
		);
		vec2 point_b = vec2(.5) + distance_b * angle_vector + vec2(
			mod(random_float(vec2(.3141 * seed * index)), .02) - .01,
			mod(random_float(vec2(.9814 * seed * index)), .02) - .01
		);
		
		float size = 2. + random_float(vec2(.9827 * seed * index)) * 4.;
		
		value = or(value, line(point_a, point_b, size, uv, screen_pixel_size));
	}
	
	return value;
}

vec4 image(sampler2D image_texture, vec2 uv) {
	vec4 image_color = vec4(1.);
	
	vec4 texture_color = texture(image_texture, scale(uv, zoom, zoom));
	if (!use_color)
		return texture_color;
	float grey = 0.299 * texture_color.r + 0.587 * texture_color.g + 0.114 * texture_color.b;
	image_color.rgb = pow(grey, .5) * color.rgb;
	return image_color;
}

vec4 image_blur(sampler2D image_texture, vec2 uv, vec2 texture_pixel_size) {
	vec2 radius = blur_size * texture_pixel_size;
	
	vec4 texture_color = image(image_texture, uv);
	int count = 0;
	for (float d = 0.; d < 2. * PI; d += PI / blur_direction) {
		for (float i = 1.0 / blur_quality; i <= 1.0; i += 1.0 / blur_quality) {
			texture_color += image(image_texture, uv + vec2(cos(d), sin(d)) * radius * i);
			count += 1;
		}
	}
	
	return texture_color / float(count);
}

vec3 chromatic_abberation(sampler2D image_texture, vec2 uv) {
	vec3 rgb = vec3(0.);
	vec3 sum = vec3(0.);
	vec2 offset = (uv - vec2(.5)) * vec2(1, -1);
	for (int i = 0; i < abberation_levels; i++) {
		float t = 2.0 * float(i) / float(abberation_levels - 1); // range 0.0 - 2.0
		vec3 slice = vec3(1.0 - t, 1.0 - abs(t - 1.0), t - 1.0);
		slice = max(slice, 0.0);
		sum += slice;
		vec2 slice_offset = (t - 1.0) * abberation_spread * offset;
		rgb += slice * image(image_texture, uv + slice_offset).rgb;
	}
	return rgb / sum;
}


void fragment() {
	if (!use_cracks_and_glass) {
		if (abs(abberation_spread - 0.0) > 0.001) {
			COLOR.a = 1.;
			COLOR.rgb = chromatic_abberation(TEXTURE, UV);
		} else {
			COLOR = image(TEXTURE, UV);
		}
	} else {
		float pixel_ratio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
		vec2 scaled_uv = scaled_vector(UV, pixel_ratio);
		vec2 scaled_refraction_offset = scaled_vector(refraction_offset, pixel_ratio);
		vec2 scaled_reflection_offset = scaled_vector(reflection_offset, pixel_ratio);
		
		float crack_color = crack(scaled_uv, TEXTURE_PIXEL_SIZE);
		float adjacent_crack_color = crack(scaled_uv + TEXTURE_PIXEL_SIZE * scaled_reflection_offset, TEXTURE_PIXEL_SIZE);
		 if (abs(adjacent_crack_color  - 1.) < 0.001) {
			// Light relection in cracks (use color)
			COLOR = mix(image(TEXTURE, UV), reflection_color, reflection_color.a);
		} else if (abs(crack_color  - 1.) < 0.001) {
			// Refraction (use adjacent color)
			COLOR = image(TEXTURE, UV + TEXTURE_PIXEL_SIZE * scaled_refraction_offset);
		} else {
			// Normal (use blur color)
			COLOR = image_blur(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
		}
	}
}