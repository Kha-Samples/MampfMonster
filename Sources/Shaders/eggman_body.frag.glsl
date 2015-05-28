#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec4 pos;
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D sample;
uniform sampler2D normals;
uniform sampler2D facetex;

float PI = 3.14159265358979323846264;
uniform vec3 lightPosition;// = vec3(100.0, 200.0, 500.0);
vec3 eye = vec3(0.0, 200.0, 500.0);

uniform float angle;
uniform vec3 center;
vec2 f1;
vec2 f2;
float ellipseConstant;

float square(float value) {
	return value * value;
}

vec3 muster(vec2 pos) {
	return vec3(sin(pos.x * 200.0) * sin(pos.y / 10.0), 1.0, 1.0);
}

float saturate(float value) {
	return clamp(value, 0.0, 1.0);	
}

float calcRadius(vec2 pos, vec2 f1, vec2 f2, float ellipseConstant) {
	float x = distance(pos.y, f1.y);
	float y = distance(pos.y, f2.y);
	float c = ellipseConstant;
	
	float bruch = (square(c) + square(x) - square(y)) / (2.0 * c);
	
	return sqrt(square(bruch) - square(x));
}

vec3 angleBisector(vec3 a, vec3 b) {
	return normalize(a / length(a) + b / length(b));
}

void kore() {
	f1 = center.xy / center.z + vec2(0.0, -0.22 / center.z); //-100
	f2 = center.xy / center.z + vec2(0.0, 0.22 / center.z); //100
	ellipseConstant = 0.485 / center.z; //245

	vec2 position = pos.xy;

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	//lightPosition.x = sin(time) * 1000.0;
	//lightPosition.y = sin(time * 0.5) * 2000.0;
	
	if (distance(position, f1) + distance(position, f2) < ellipseConstant) {
		float radius = calcRadius(position, f1, f2, ellipseConstant);
		float winkel = asin(abs(position.x - center.x / center.z) / radius);
		
		float z = radius * cos(winkel);
		//z = sqrt(square(radius) - square(position.x - center.x));
		//z *= 0.01;
		vec3 world = vec3(position, z);
		//vec3 normal = normalize(world - vec3(center, 0.0));

		vec3 normal = angleBisector(world - vec3(f1, 0.0), world - vec3(f2, 0.0));

		vec3 tangent = angleBisector(world - vec3(f2, 0.0), vec3(f1, 0.0) - world);

		if (position.x < center.x / center.z) winkel = PI / 2.0 - winkel;
		else winkel += PI / 2.0;
		winkel -= angle;
		winkel /= PI * 2.0;

		vec2 texcoord = vec2(winkel, 1.0 - (position.y - center.y / center.z + ellipseConstant / 2.0) / ellipseConstant);

		vec3 tangentnormal = texture2D(normals, texcoord).rgb * 2.0 - 1.0;
		normal.x = dot(tangentnormal, cross(tangent, normal));
		normal.y = dot(tangentnormal, tangent);
		normal.z = dot(tangentnormal, normal);
		normal = normalize(normal);

		vec3 lightDirection = normalize(world - lightPosition);
		//lightDirection = vec3(0.1, 0.2, -0.7);
		float diffuse = saturate(dot(normal, -lightDirection));
		vec3 h = normalize(normalize(eye - world) - lightDirection);
		float specular = pow(saturate(dot(h, normal)), 15.0);
		float light = 0.2 + diffuse * 0.5;
		
		float alpha = texture2D(facetex, texcoord).a;
		vec3 tex = texture2D(facetex, texcoord).rgb * alpha + texture2D(sample, texcoord).rgb * (1.0 - alpha);
		gl_FragColor = vec4(tex * light + specular * (1.0 - alpha), 1.0);
	}
	else discard;
}
