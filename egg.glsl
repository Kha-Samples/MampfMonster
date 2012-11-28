#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 muster(vec2 pos) {
	return vec4(sin(pos.x * 200.0) * sin(pos.y * 200.0), 1.0, 1.0, 1.0);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec2 center = vec2(position.x - 0.7, position.y - 0.5);

	vec2 pos = position;
	pos.x += time / 100.0;
	if (sqrt(center.x * center.x * 5.0 + center.y * center.y) < 0.2) {
		gl_FragColor = muster(pos);
	}
}