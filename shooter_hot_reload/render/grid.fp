varying mediump vec2 var_texcoord0;

uniform lowp vec4 time;
 
vec3 sampleVoronoi(vec2 uv, float size)
{	
	float nbPoints = size * size;
	float m = floor(uv.x * size);
	float n = floor(uv.y * size);
	
	vec3 voronoiPoint = vec3(0.0);	
	float dist2Max = 3.0;
	const float _2PI = 6.28318530718;
	
	for(int i = -1; i < 2; i++) { 
		for(int j = -1; j < 2; j++) {
			vec2 coords = vec2(m + float(i), n + float(j));
			float phase = _2PI * (size * coords.x + coords.y) / nbPoints;
			vec2 delta = 0.7 * vec2(sin(time.x + phase), cos(time.x + phase));
			vec2 point = (coords + vec2(0.5) + delta) / size;
			vec2 dir = uv - point;
			float dist2 = dot(dir, dir);
						
			float t = 0.5 * (1.0 + sign(dist2Max - dist2));
			vec3 tmp = vec3(point, dist2);
			dist2Max = mix(dist2Max, dist2, t);
			voronoiPoint = mix(voronoiPoint, tmp, t);
		}
	}
	return voronoiPoint;
}

void main()
{	
	float size = 6.0;
	vec3 voronoi = sampleVoronoi(var_texcoord0, size);
	float t = exp(-1.0 * size * voronoi.x) * voronoi.y;
	gl_FragColor = vec4(voronoi.x / 2.0, 0.2, voronoi.z * t * 100.0, t * 10.0);
}
