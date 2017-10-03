varying mediump vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform lowp sampler2D tex0;
uniform highp vec4 anim;
uniform highp vec4 prop;

void main()
{
	// Exctract properties and animation data
	float divider = prop.x;
	float dt = anim.x;
	float a = anim.y;
	
	if (var_texcoord0.x > divider) {
		// Perform post process effects
		vec2 coords = var_texcoord0.xy;
		//coords.y += sin(coords.x*a*100.0)*0.02;
		vec4 color = texture2D(tex0, coords.xy);
		color.rgb = color.rrr;
		gl_FragColor = vec4(color.rgb,1.0);
	} else {
		// No post process, just output input texture
		vec4 color = texture2D(tex0, var_texcoord0.xy);
		gl_FragColor = vec4(color.rgb,1.0);
	}

    
}

