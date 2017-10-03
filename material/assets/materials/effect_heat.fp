varying mediump vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform lowp sampler2D tex0;
uniform lowp sampler2D tex1;
uniform highp vec4 anim;
uniform highp vec4 prop;

void main()
{
	// Exctract properties and animation data
	float divider = prop.x;
	float dt = anim.x;
	float a = anim.y;

	
	vec2 uv0 = var_texcoord0.xy;
	if (var_texcoord0.x > divider) {
		// Perform heat effect
		vec2 uv1 = var_texcoord0.xy;
		vec4 norm_map = texture2D(tex1, uv1.xy + vec2(sin(-uv0.y*4.0+a*1.5)*0.04, -a*0.1));
		uv0.xy += (norm_map.xy*2.0 - 1.0)*0.03*(1.0 - uv0.y);
	}
	vec4 color = texture2D(tex0, uv0.xy);

    gl_FragColor = vec4(color.rgb,1.0);
}

