#version 450

in vec3 pos;
in vec2 tex;
out vec2 texcoord;

void main() {
	texcoord = tex;
	gl_Position = vec4(pos.x, pos.y, pos.z * pos.z, pos.z);
}
