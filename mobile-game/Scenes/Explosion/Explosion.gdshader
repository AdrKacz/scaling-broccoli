shader_type canvas_item;

uniform float animation_duration = 1;
uniform float time:  hint_range(0, 1) = 0;

const vec4 hash_scale_4 = vec4(.1031, .1030, .0973, .1099);
vec4 hash41(float p) {
        vec4 p4 = fract(vec4(p) * hash_scale_4);
    p4 += dot(p4, p4.wzxy+19.19);
    return fract((p4.xxyz+p4.yzzw)*p4.zywx);   
}

vec3 hsv2rgb(in vec3 c){
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
	return c.z * mix( vec3(1.0), rgb, c.y);
}

const float half_PI = PI * .5;
vec4 explosion(vec2 uv, vec2 iResolution){
	float AA = 10. / iResolution.x;
    vec4 res = vec4(0.);
    
    {
        vec2 pol = vec2(length(uv), atan(uv.x, uv.y));
        float n = floor((pol.y * 15.)/PI);
        pol.y = mod(pol.y * 15., PI)/PI;
        pol.y = 2. * pol.y - 1.;
        pol.y *= pol.x * PI;
        pol.x *= 20.;
        
        vec4 h = hash41(n * .17);
        float s = (.25 + h.y * .5) * smoothstep(.25, .3, time) * smoothstep(.55, .5, time);
        
        float start = 40. * smoothstep(.3, .5, time) * (2. - h.x);
        float end = 40. * smoothstep(.3, .4, time) * (2. - h.x);
        float width = (end - start)/2.;
        float mid = start + width;
        float v = mix(smoothstep(s + AA, s, abs(pol.y)),
                      max(smoothstep(s + AA, s, distance(vec2(start, 0.), pol)),
                          smoothstep(s + AA, s, distance(vec2(end, 0.), pol))),
                      step(width, distance(pol.x, mid)));
        res = mix(res, vec4(hsv2rgb(vec3(1. + (h.w * .2 - .1), smoothstep(.6, .4, time), 1.)), 1.), v * step(0., uv.y));
    }
    
    for(int i=0; i<12; i++){
        vec4 hash = hash41(float(i));
        
        vec3 color = hsv2rgb(vec3(time * .2 + (hash.x * .1 - .05), 1., 1.));
        
        float startTime = hash.x * .2;
        float size = smoothstep(startTime, startTime + .1, time) * (.5 + hash.z * .25)
                   * smoothstep(.65 - startTime, .6 - startTime, time);
        float ang = (hash.y * 2. - 1.) * PI - half_PI;
        float rad = .3 + smoothstep(.3, .4, time) * (2. - hash.x) * .6;
        vec2 pos = vec2(rad * sin(ang), rad * cos(ang));
        vec4 clr = vec4(color, smoothstep(.01, 0., distance(uv, pos) - size));
        
        
        size = smoothstep(startTime + .2, startTime + .3, time) * (.5 + hash.z * .25);
        rad = smoothstep(startTime + .35, startTime + .4, time) * (2. - hash.x) * .75;
        pos = vec2(rad * sin(ang), rad * cos(ang));
        clr = mix(vec4(clr.rbg, 0.), clr, smoothstep(0., .01, distance(uv, pos) - size));
        
        res = mix(res, clr, clr.a);
    }
    
    return res;
}

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	// explosion mask
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = (2. * FRAGCOORD.xy - iResolution.xy) / iResolution.y;
	
    vec4 explosion_frame = explosion(uv * 3., iResolution);
	float explosion_mask = 1. - explosion_frame.a;
	
	// circular mask
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float circle_size = max(.0, 2. * time - 1.);
	float circle_mask = step(circle_size, length(scaledUV - center));
	
	float mask = 1. - explosion_mask * circle_mask;

	// apply black and white filter
	vec4 pixel = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = mask * ceil(pixel.rgb) + pixel.rgb;
}
