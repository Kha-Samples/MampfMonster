#version 100

attribute vec3 pos;
attribute vec2 tex;
varying vec2 texcoord;
varying vec3 world;

void kore() {
	texcoord = tex;
	world = vec3(pos.x, pos.y, 0);
	gl_Position = vec4(pos.x, pos.y, 0.5, pos.z);
}
