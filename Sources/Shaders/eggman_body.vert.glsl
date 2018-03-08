#version 450

in vec3 position;
out vec4 pos;

void main() {
	gl_Position = pos = vec4(position, 1.0);
}
