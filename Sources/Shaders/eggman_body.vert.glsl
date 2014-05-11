#version 100

attribute vec3 position;
varying vec4 pos;

void kore() {
	gl_Position = pos = vec4(position, 1.0);
}
