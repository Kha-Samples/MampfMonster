#version 100

attribute vec3 pos;
attribute vec2 tex;
varying vec4 position;
varying vec2 texcoord;

void kmain() {
	texcoord = tex;
	gl_Position = position = vec4(pos.x, pos.y, pos.z * pos.z, pos.z);
}
