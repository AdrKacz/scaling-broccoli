shader_type canvas_item;
uniform float seed: hint_range(0.0, 1.0, 0.01) = 0.12345678;
uniform float resolution: hint_range(2, 128, .1) = 64.;
uniform bool use_pixel = true;

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0);
}

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

float and(float a, float b) {
  return a * b;
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

float circle(vec2 position, vec2 origin, float radius, float feather) {
	return smoothstep(radius, radius + feather, length(position - origin));
}

float circle_stroke(vec2 position, vec2 origin, float radius, float feather, float stroke_width) {
	return circle(position, origin, radius - stroke_width, feather) - circle(position, origin, radius, feather);
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

int random_int (vec2 uv) {
    return int(floor(random_float(uv) * 100000. * (1. + seed)));
}

void fragment() {
	vec2 uv = float(use_pixel) * (round(UV * resolution) / resolution) + (1. - float(use_pixel)) * UV;
	float value = 0.;
	
	// Add circles (radius between 0 excluded and 0.5 included)
	int number_of_circles = 4 + random_int(vec2(seed)) % 2;
	float radius_step = 0.5 / float(number_of_circles);
	for (int i = 0; i < number_of_circles; i++) {
		float index = 1. * float(i);
		vec2 offset = vec2(
			mod(random_float(vec2(.8721 * seed * index)), .02) - .01,
			mod(random_float(vec2(.1837 * seed * index)), .02) - .01
		);

		float radius = radius_step * float(i);
		radius += mod(random_float(vec2(.1204 * seed * index)), 0.02) - 0.01;
		radius = max(0.01, radius);
		
		float angle = random_float(vec2(.8294 * seed * index)) * 2. * PI;
		float rotation = random_float(vec2(.0185 * seed * index)) * 2. * PI;
		value = or(value, arc(uv, vec2(.5) + offset, radius, 0.02, 0.005, angle, rotation));
	}
	
	// Add lines
	int number_of_lines = 15 + random_int(vec2(seed)) % 5;
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
		
		float size = 10. + random_float(vec2(.9827 * seed * index)) * 20.;
		
		value = or(value, line(point_a, point_b, size, uv, SCREEN_PIXEL_SIZE));
	}
	
	COLOR.rgb = vec3(value);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
