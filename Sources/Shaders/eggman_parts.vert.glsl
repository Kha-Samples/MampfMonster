attribute vec3 pos;
attribute vec2 tex;
varying vec4 position;
varying vec2 texcoord;

void main() {
	texcoord = tex;
	gl_Position = position = vec4(pos.x, pos.y, 0.5, pos.z);
}