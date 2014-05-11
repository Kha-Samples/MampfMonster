#version 100

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec3 lightPosition;// = vec3(100.0, 200.0, 500.0);
vec3 eye = vec3(0.0, 200.0, 500.0);
uniform sampler2D sampler;
uniform sampler2D normals;
uniform float time;
varying vec2 texcoord;

float saturate(float value) {
	return clamp(value, 0.0, 1.0);	
}

void kore() {
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	//lightPosition.x = sin(time) * 1000.0;
	//lightPosition.y = sin(time * 0.5) * 2000.0;
	//vec2 position = gl_FragCoord.xy;
	//vec2 texcoord = (position.xy + 1.0) / 2.0;
	vec3 normal = texture2D(normals, texcoord).rgb * 2.0 - 1.0;
	
	vec3 world = vec3(gl_FragCoord.xy, 0);
	world.x /= resolution.x;
	world.y /= resolution.y;
	vec3 lightDirection = normalize(world - lightPosition);
	//lightDirection = vec3(0.1, 0.2, -0.7);
	float diffuse = saturate(dot(normal, -lightDirection));
	vec3 h = normalize(normalize(eye - world) - lightDirection);
	float specular = pow(saturate(dot(h, normal)), 15.0);
	float light = 0.2 + diffuse * 0.5;
	
	float a = texture2D(sampler, texcoord).a;
	gl_FragColor = vec4(texture2D(sampler, texcoord).xyz * light + specular * a, a);
}
