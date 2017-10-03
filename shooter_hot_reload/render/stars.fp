#define iterations 17
#define formuparam 0.53

#define volsteps 2
#define stepsize 0.15

#define zoom   0.800
#define tile   0.850
#define speed  0.040

#define brightness 0.0015
#define darkmatter 0.300
#define distfading 0.730
#define saturation 0.750

varying mediump vec2 var_texcoord0;
uniform lowp vec4 time;

void main()
{
	//get coords and direction
	vec2 res = vec2(1.0, 0.44);
	vec2 uv = var_texcoord0.xy / res.xy - 0.5;
	uv.y *= res.y / res.x;
	vec3 dir = vec3(uv * zoom, 1.0);
	float time = time.x * speed + 0.25;

	vec3 from = vec3(1.0, 0.5, 0.5);
	from += vec3(1.0 * sin(time * 50.0) / 200.0, time, -2.0);
	
	//volumetric rendering
	float s = 0.1, fade = 1.0;
	vec3 v = vec3(0.0);
	for(int r = 0; r < volsteps; r++) {
		vec3 p = from + s * dir * 0.5;
		// tiling fold
		p = abs(vec3(tile) - mod(p, vec3(tile * 2.0)));
		float pa, a = pa = 0.0;
		for (int i=0; i < iterations; i++) { 
			// the magic formula
			p = abs(p) / dot(p, p) - formuparam;
			// absolute sum of average change
			a += abs(length(p) - pa);
			pa = length(p);
		}
		//dark matter
		float dm = max(0.0, darkmatter - a * a * 0.001);
		a *= a * a;
		// dark matter, don't render near
		if(r > 6) fade *= 1.0 - dm;
		v += fade;
		// coloring based on distance
		v += vec3(s, s * s, s * s * s * s) * a * brightness * fade;
		fade *= distfading; 
		s += stepsize;
	}
	//color adjust
	v = mix(vec3(length(v)), v, saturation);
	gl_FragColor = vec4(v * 0.01, 0.0);
}