#version 450

in vec3 pos;
in vec2 tex;
out vec2 texcoord;
out vec3 world;

void main() {
	texcoord = tex;
	world = vec3(pos.x, pos.y, 0);
	gl_Position = vec4(pos.x, pos.y, 0.5, pos.z);
}
